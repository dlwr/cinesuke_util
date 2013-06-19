# -*- coding: utf-8 -*-
require 'rubygems'
require 'yaml'
require 'open-uri'
require 'nokogiri'
require 'mongoid'
require 'mongo'
require 'date'

def open_without_garble(url)
  begin
    html = open(url, "r:binary").read.force_encoding("UTF-8")
  rescue
    nil
  else
    doc = Nokogiri::HTML(html, nil, 'utf-8')
  end
end

Mongoid.load!("mongoid.yml", :development)

class Theater
  include Mongoid::Document

  field :name
  field :address
  field :eiga_dot_com_url
  has_and_belongs_to_many :movies
  has_many :screens
end

class Screen
  include Mongoid::Document

  field :start_time, type: Time
  field :remarks
  field :gcaled, type: Boolean, default: false
  belongs_to :movie
  belongs_to :theater
end

class Movie
  include Mongoid::Document

  field :title
  field :description
  field :length, type: Integer
  field :release_date, type: Time
  field :director
  field :cast, type: Array
  has_and_belongs_to_many :theater
end

EIGA_DOT_COM = "http://eiga.com"
EIGA_DOT_COM_TOKYO_THEATER_LIST = EIGA_DOT_COM + "/theater/13/"
MOVIE_WALKER = "http://movie.walkerplus.com"

def update_theater_list
  url = EIGA_DOT_COM_TOKYO_THEATER_LIST
  document = open_without_garble(url)
  theaterList = document.search('//*[@class="theaterList"]/li')
  theaterList.each { |t|
    theaterName = t.search('a').text
    theaterLink = t.search('@href').text
    theaterAddress = t.search('p').text
    unless Theater.where(name: theaterName).exists?
      theater = Theater.new(name: theaterName, address: theaterAddress, eiga_dot_com_url: theaterLink)
      theater.save
    end
  }
end

def update_movies_list
  Theater.each {|theater|
    puts theater.name
    url = EIGA_DOT_COM + theater.eiga_dot_com_url
    document = open_without_garble(url)
    if document == nil
      puts "	" + theater.name + "のページが見つかりません！！"
      next
    end
    movieList = document.search('[@class="itemBox"]')
    movieList.each { |m|
      title = m.search('h4').text
      next if title == ""
      if Movie.where(title: title).exists?
        if Movie.where(title: title)[0].length == 0
          Movie.where(title: title).delete
        else
          next
        end
      end
      mDataTable = m.search('[@class="mData"]/table/tr/td')
      rda = mDataTable[0].text.split(/[年,月,日]/).map {|s| s.to_i}
      if (rda == nil || rda.size < 3 || rda[1] < 1 || 12 < rda[1] || rda[2] < 1 || 31 < rda[2])
        releaseDate = nil
      else
        releaseDate = DateTime.new(rda[0], rda[1], rda[2])
      end
      length = mDataTable[2].text.to_i
      atag = m.at('ul/li[2]/a[@title="' + title + '"]')
      infoLink = atag.search('@href').text unless atag == nil
      if infoLink
        infoUrl = EIGA_DOT_COM + infoLink
        infoDoc = open_without_garble(infoUrl)
        description = infoDoc.search('p[@property="v:summary"]').text
        director = infoDoc.search('a[@rel="v:directedBy"]').text
        cast = []
        infoDoc.search('[@class="castBox"]/ul/li//a').each { |p|
          cast << p.text
        }
      end
      unless Movie.where(title: title).exists?
        movie = Movie.new(title: title, description: description, length: length, release_date: releaseDate, director: director, cast: cast)
        movie.save
        puts "	save " + title
      end
    }
  }
end

def update_screen
  Screen.delete_all
  Theater.each {|theater|
    url = EIGA_DOT_COM + theater.eiga_dot_com_url
    document = open_without_garble(url)
    if document == nil
      puts "	" + theater.name + "のページが見つかりません！！"
      next
    end
    movieList = document.search('[@class="itemBox"]')
    puts theater.name
    movieList.each {|m|
      title = m.search('h4').text
      next if title == ""
      unless Movie.where(title: title).exists?
        puts title + "がデータベースに見つかりません"
        next
      end
      atag = m.search('[@class="mSche"]/ul/li[1]')[0]
      remarks = m.search('[@class="mSche"]/p').text
      scheduleLink = atag.search('@href').text unless atag == nil
      if scheduleLink
        scheduleUrl = EIGA_DOT_COM + scheduleLink
        scheduleDoc = open_without_garble(scheduleUrl)
        if (scheduleDoc == nil)
          next
        end
        schedule = Hash.new()
        date = scheduleDoc.search('[@class="mSche"]/table/tr/th')
        time = scheduleDoc.search('[@class="mSche"]/table/tr/td')
        (0...date.size).each {|i|
          schedule[date[i].text.gsub(/ |（.*）/, "")] = time[i].text.gsub(/\|.*/, "").split(" ")
        }
      end
      movie = Movie.where(title: title)[0]
      puts "	" + movie.title

      schedule.each {|date, times|
      next if times == []
      month = date.split("/")[0].to_i
      day = date.split("/")[1].to_i
        times.each {|time|
          hour = time.split(":")[0].to_i
          minute = time.split(":")[1].to_i
          midnight = false
          if hour >= 24
            hour = hour - 24
            midnight = true
          end
          startTime = Time.local(2013, month, day, hour, minute)
          Screen.find_or_create_by(start_time: startTime,
                                   remarks: remarks,
                                   theater: theater,
                                   movie: movie)
        }
      }
    }
  }
end

def movie_now
  now_movie = Hash.new()
  Screen.each {|screen|
    now_movie[Movie.where(_id: screen.movie_id)[0].title] = true
  }
  Movie.each {|movie|
    if now_movie[movie.title] == true
      movie.update_attribute(:now, true)
    else
      movie.update_attribute(:now, false)
    end
    movie.save
  }
end

# update_theater_list
update_movies_list
update_screen
movie_now
