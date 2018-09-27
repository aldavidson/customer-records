# Allows us to initialize a Hash directly from a JSON representation
# (which always gives string keys) and auto-convert to symbol keys
# similarly to Rails' Hash.symbolize_keys! method
class HashSymbolizer
  def self.symbolize(hash)
    symbolized_hash = {}
    hash.each do |key, value|
      symbolized_hash.store(key.to_sym, value)
    end
    symbolized_hash
  end
end
