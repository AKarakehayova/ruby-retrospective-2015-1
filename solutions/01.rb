def convert_to_bgn(price, currency)
  result = case currency
            when :usd then price * 1.7408
            when :eur then price * 1.9557
            when :gbp then price * 2.6415
            when :bgn then price
           end
  result.round(2)
end

def compare_prices(price, currency, price_two, currency_two)
  convert_to_bgn(price, currency) <=> convert_to_bgn(price_two, currency_two)
end
