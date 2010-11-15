require 'rubygems'
require 'yaml'


SECTORS = {'Aderezo' => 1, 'Carnes frescas, mataderos y salas de despiece' => 2, 'Conservas, semiconservas y zumos vegetales' => 3, 'Embutidos y jamones' => 4, 'Galletas, confitería y pastelería' => 5, 'Hortofrutícolas' => 6, 'Leche, quesos y derivados lácteos' => 7, 'Panificación y pastas alimenticias' => 8, 'Preparados alimenticios' => 9, 'Aceite' => 10, 'Comercializadoras' => 11, 'Especias, aromáticas y medicinales' => 12, 'Frutos secos' => 13, 'Granos y legumbres' => 14, 'Huevos' => 15, 'Miel y otros productos apícolas' => 16, 'Piscicultura' => 17, 'Vinos, cavas, brandys, y licores' => 18, 'Vinagres' => 19, 'Otros' => 20}
col = ["EMPRESA","CONTACTO","CARGO",
  "ADEREZO","CARNESFRESCASMATADEROSYSALASDEDESPIECE",
  "CONSERVASSEMICONSERVASYZUMOSVEGETALES","Embutidos y jamones","Galletas, confitería y pastelería","Hortofrutícolas",
  " Leche, quesos y derivados lácteos","Panificación y pastas alimenticias ","Preparados alimenticios",
  "Aceite","Comercializadoras","ESPECIASAROMATICASYMEDICINALES","FRUTOSSECOS","GRANOSYLEGUMBRES",
  "Huevos","MIELYOTROSPRODUCTOSAPICOLAS","Piscicultura","VINOSCAVASBRANDYSYLICORES","Vinagres","Otros",
  "Direccion","cp","Localidad","Provincia","telefono","Fax","Email","Web"]
EXPOSITORES = col.map {|name| name.mb_chars.decompose.scan(/[a-zA-Z0-9]/).join.upcase}

SECTORES = {}
Sector.all.each do |s|
  key = s.name.mb_chars.decompose.scan(/[a-zA-Z0-9]/).join.upcase
  SECTORES[key] = s.id
end

class Importer
  def initialize(rol_id, filename, names)
    raise Exception.new("NO ROL!") if rol_id.blank?

    file = File.new(filename, 'r')

    file.each_line("\n") do |line|
      row = line.split(";")
      data = {}
      names.each_with_index do |name, index|
        value = row[index].nil? ? '"NULL"' : row[index].strip
        value = value[1..-2] if value.length > 1
        data[name] = value.strip
      end
      blah(data)
    end
  end

  def blah(data)
    params = {:role_id => 5, :profile_attributes => {:sector_ids => []}}
    params[:preference_id] = 1
    profile = params[:profile_attributes]

    SECTORES.keys.each do |sec|
      profile[:sector_ids] << SECTORES[sec] if data[sec].present?
      data.delete(sec)
    end

    profile[:company_name] = data.delete('EMPRESA')
    profile[:contact_person] = "#{data.delete('CONTACTO')} (#{data.delete('CARGO')})"
    profile[:zip_code] = data.delete('CP')
    profile[:phone] = data.delete('TELEFONO').to_i
    profile[:fax] = data.delete('FAX').to_i
    profile[:address] = data.delete('DIRECCION')
    params[:email] = data.delete('EMAIL').downcase
    profile[:website] = data.delete('WEB')
    provname = data.delete('PROVINCIA')
    province = Province.find_by_name(provname)
    raise Exception.new("Provincia no encontrada: #{provname}") if province.nil?
    profile[:province_id] = province.id
    locname = data.delete('LOCALIDAD')
    local = Town.find_by_name(locname)
    if local.nil?
      puts "LOCALIDAD NO ENCONTRADA: #{locname}"
    else
      profile[:town_id] = local.id
    end

    
    raise Exception.new("Sobran datos #{data.to_yml}") if data.size > 0
    user = User.new(params)
    user.password = String.password
    user.login = user.profile.company_name.normalize
    raise Exception.new("No válido: #{user.errors.to_yaml}") unless user.valid?
    puts "Válido"
    if DEBUG 
    elsif  user.save!
      puts "Guardado!"
    end
  end
end

DEBUG = false
Importer.new(5, "db/import/expositores.csv", EXPOSITORES)


