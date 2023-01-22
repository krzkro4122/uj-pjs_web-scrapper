#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'pp'

puts "Collecting amazons HTML..."

# Fetch and parse HTML document
doc = Nokogiri.HTML(
    URI.open(
        'https://www.amazon.pl/s?k=ziemniaki&crid=3SZU64CCMVZ26&sprefix=ziemniaki%2Caps%2C105&ref=nb_sb_ss_ts-doa-p_1_9',
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
        'sec-ch-ua' => '"Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"',
        'accept-language' => 'pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7'
    )
)

# Search for nodes by css
items = []
idCounter = 0

# Iterate over all item cards
doc.css('div.s-main-slot.s-result-list.s-search-results.sg-row').each do |cardContainer|


    # Collect titles and prices for each item Card element
    cardContainer.css('div.sg-col-4-of-24.sg-col-4-of-12.s-result-item.s-asin.sg-col-4-of-16.AdHolder.sg-col.s-widget-spacing-small.sg-col-4-of-20').each do |card|

        title = ""
        price = ""

        card.css('a span.a-size-base-plus.a-color-base.a-text-normal').each do |titleElement|
            title = titleElement.text
        end

        card.css('span.a-price span.a-offscreen').each do |priceElement|
            price = priceElement.text
        end

        items.push({
            id: idCounter,
            title: title,
            price: price
        })
        idCounter += 1

    end
end

pp items
