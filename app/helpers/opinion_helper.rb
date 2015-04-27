module OpinionHelper
  def get_rating(search_term, date)

    sample_size = 100.0
    current_rating = 0.0
    search = '"' + URI.escape(search_term) + '"'

    twitter_api.search(search_term, result_type: 'recent').take(sample_size).each do |tweet|
      rating = get_opinion(tweet.text, positive_words, negative_words)

      if rating == 0
        sample_size -= 1 #Remove people will no opinion on the matter
      else
        current_rating += rating
      end
      #tweets.push tweet.text
    end

    # Make the current rating positive
    current_rating += sample_size
    #current_rating += sample_size
    #current_rating.to_s + " " + sample_size.to_s

    # Get the percent from the rating
    ((current_rating / (sample_size*2)) * 100).round
  end

  def get_opinion(text_string, positive_words, negative_words)
    words = text_string.split
    positive_words_count = (words & positive_words).length - (words & negative_words).length

    if positive_words_count > 0 then
      1
    else
      positive_words_count < 0 ? -1 : 0
    end
  end

  def negative_words
    @negative_words ||= File.open(Rails.root.join('app/assets/words/negative-words.txt')).readlines.each do |word|
      word.strip!
    end
  end

  def positive_words
    @positive_words ||= File.open(Rails.root.join('app/assets/words/positive-words.txt')).readlines.each do |word|
      word.strip!
    end
  end

  def twitter_api
    @twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key = 'xxx'
      config.consumer_secret = 'xxx'
      config.access_token = 'xxxx'
      config.access_token_secret = 'xxxxx'
    end
  end
end
