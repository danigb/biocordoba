class String
  # Normalizar una cadena por Xavier Noria
  def normalize
    return '' if self.nil?
    n = self.downcase.strip.to_s
    n.gsub!(/[àáâãäåāă]/,    'a')
    n.gsub!(/æ/,            'ae')
    n.gsub!(/[ďđ]/,          'd')
    n.gsub!(/[çćčĉċ]/,       'c')
    n.gsub!(/[èéêëēęěĕė]/,   'e')
    n.gsub!(/ƒ/,             'f')
    n.gsub!(/[ĝğġģ]/,        'g')
    n.gsub!(/[ĥħ]/,          'h')
    n.gsub!(/[ììíîïīĩĭ]/,    'i')
    n.gsub!(/[įıĳĵ]/,        'j')
    n.gsub!(/[ķĸ]/,          'k')
    n.gsub!(/[łľĺļŀ]/,       'l')
    n.gsub!(/[ñńňņŉŋ]/,      'n')
    n.gsub!(/[òóôõöøōőŏŏ]/,  'o')
    n.gsub!(/œ/,            'oe')
    n.gsub!(/ą/,             'q')
    n.gsub!(/[ŕřŗ]/,         'r')
    n.gsub!(/[śšşŝș]/,       's')
    n.gsub!(/[ťţŧț]/,        't')
    n.gsub!(/[ùúûüūůűŭũų]/,  'u')
    n.gsub!(/ŵ/,             'w')
    n.gsub!(/[ýÿŷ]/,         'y')
    n.gsub!(/[žżź]/,         'z')
    n.gsub!(/\s+/,           '-')
    n.gsub!(/\./,            '')
    #Migue, el donwcase no afecta a los siguientes caracteres
    n.gsub!(/\,/,            '')
    n.gsub!(/Á/,            'a')
    n.gsub!(/É/,            'e')
    n.gsub!(/Í/,            'i')
    n.gsub!(/Ó/,            'o')
    n.gsub!(/Ú/,            'u')
    n.gsub!(/Ñ/,            'n')
    n.gsub!(/'/,            '')
    n.gsub!(/&/,            '-AND-')
    n.gsub!(/\(/,            '')
    n.gsub!(/\)/,            '')
    n.gsub!(/"/,            '')

    # n.tr!('^ a-z0-9_/\\-',    '')
    n[0..25]
  end 

  def extract_acute
    replace = {"&aacute;" => "á", "&eacute;" => "é","&iacute;" => "í","&oacute;" => "ó","&uacute;" => "ú",
               "&Áacute;" => 'Á', "&Eacute;" => 'É',"&Iacute;" => 'Í',"&Oacute;" => 'Ó',"&Uacute;" => 'Ú',
               "&ntilde;" => 'ñ'
    }
    replace.each do |k, v|
      self.gsub!(k, v)
    end
    self
  end

  def self.password(length=5)
    Digest::MD5.hexdigest(Time.now.to_s)[0..length]
    #Haddock::Password.generate(length)
  end
end
