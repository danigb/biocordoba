require 'rubygems'
require 'yaml'


SECTORS = {'Aderezo' => 1, 'Carnes frescas, mataderos y salas de despiece' => 2, 'Conservas, semiconservas y zumos vegetales' => 3, 'Embutidos y jamones' => 4, 'Galletas, confitería y pastelería' => 5, 'Hortofrutícolas' => 6, 'Leche, quesos y derivados lácteos' => 7, 'Panificación y pastas alimenticias' => 8, 'Preparados alimenticios' => 9, 'Aceite' => 10, 'Comercializadoras' => 11, 'Especias, aromáticas y medicinales' => 12, 'Frutos secos' => 13, 'Granos y legumbres' => 14, 'Huevos' => 15, 'Miel y otros productos apícolas' => 16, 'Piscicultura' => 17, 'Vinos, cavas, brandys, y licores' => 18, 'Vinagres' => 19, 'Otros' => 20}
INTERNACIONALES = ["NUM","LOGIN", "PAIS","EMPRESA","PERFIL","WEB","CONTACTO","IDIOMAS","ACEITE DE OLIVA","VINO","VINAGRE","ACEITUNAS","ENCURTIDOS","CARNE","PANADERIA","PASTELERIA","ESPECIAS","QUESO","MIEL","LEGUMBRES","CONSERVAS VEGETALES","CONSERVAS PESCADO","ALIMENTOS PREPARADOS","FRUTAS Y VERDURAS","FRUTOS SECOS","OTROS"]
EXPOSITORES = ["EMPRESA","Persona de contacto","Cargo","Aderezo","Carnes frescas, mataderos y salsas de despiece",
  "Conservas, semiconservas y zumos vegetales","Embutidos y jamones","Galletas, confitería y pastelería","Hortofrutícolas",
  " Leche, quesos y derivados lácteos","Panificación y pastas alimenticias ","Preparados alimenticios",
  "Aceite","Comercializadoras","ESPECIASAROMATICASYMEDICINALES","FRUTOSSECOS","GRANOSYLEGUMBRES",
  "Huevos","MIELYOTROSPRODUCTOSAPICOLAS","Piscicultura","VINOSCAVASBRANDYSYLICORES","Vinagres","Otros",
  "Direccion","cp","Localidad","Provincia","telefono","Fax","Email","Web"]
PAISES_NOMBRES = []
PAISES = {}
Country.all.each do |c|
  key = c.name.mb_chars.decompose.scan(/[a-zA-Z0-9]/).join.upcase
  PAISES[key] = c.id
  PAISES_NOMBRES << key
end

SECTORES_NOMBRES = ""
SECTORES = {}
Sector.all.each do |s|
  key = s.name.mb_chars.decompose.scan(/[a-zA-Z0-9]/).join.upcase
  SECTORES[key] = s.id
  SECTORES_NOMBRES << "#{key} | "
end
CAT_SUS = {'ACEITE DE OLIVA' => 'ACEITE',
  'VINO' => 'VINOSCAVASBRANDYSYLICORES',
  'VINAGRE' => 'VINAGRES',
  'EMBUTIDOS Y JAMONES' => 'EMBUTIDOSYJAMONES',
  'GALLETAS, CONFITERíA Y PASTELERíA' =>  'GALLETASCONFITERIAYPASTELERIA',
  'ACEITUNAS' => 'ACEITUNASYENCURTIDOS',
  'ENCURTIDOS' => 'ACEITUNASYENCURTIDOS',
  'CONSERVAS, SEMICONSERVAS Y ZUMOS VEGETALES' => 'CONSERVASSEMICONSERVASYZUMOSVEGETALES',
  'CARNES FRESCAS, MATADEROS Y SALSAS DE DESPIECE' => 'CARNESFRESCASMATADEROSYSALASDEDESPIECE',
  'CARNE' => 'CARNESFRESCASMATADEROSYSALASDEDESPIECE',
  'ESPECIAS' => 'ESPECIASAROMATICASYMEDICINALES',
  ' LECHE, QUESOS Y DERIVADOS LáCTEOS' => 'LECHEQUESOSYDERIVADOSLACTEOS',
  'QUESO' => 'LECHEQUESOSYDERIVADOSLACTEOS',
  'CONSERVAS PESCADO' => 'CONSERVASSEMICONSERVASYZUMOSVEGETALES',
  'PANIFICACIóN Y PASTAS ALIMENTICIAS ' => 'PANIFICACIONYPASTASALIMENTICIAS',
  'PANADERIA' => 'PANIFICACIONYPASTASALIMENTICIAS',
  'CONSERVAS VEGETALES' => 'CONSERVASSEMICONSERVASYZUMOSVEGETALES',
  'PREPARADOS ALIMENTICIOS' => 'PREPARADOSALIMENTICIOS',
  'ALIMENTOS PREPARADOS' => 'PREPARADOSALIMENTICIOS',
  'MIEL' => 'MIELYOTROSPRODUCTOSAPICOLAS',
  'HORTOFRUTíCOLAS' =>  'HORTOFRUTICOLAS',
  'FRUTAS Y VERDURAS' => 'HORTOFRUTICOLAS',
  'LEGUMBRES' => 'GRANOSYLEGUMBRES',
  'FRUTOS SECOS' => 'FRUTOSSECOS'
}


UROLES = {:expositor => 5, :nacional => 3, :internacional => 4}

class Importer
  def initialize(rol, filename, columns)
    import(UROLES[rol], filename, columns)
  end

  def import(role_id, filename, columns)
    raise Exception.new("NO ROL!") if role_id.blank?
    
    file = File.new(filename, 'r')

    file.each_line("\n") do |line|
      row = line.split(";")
      process(role_id, row, columns)
    end
  end

  def process(role_id, row, columns)
    params = {:role_id => role_id, :profile_attributes => {:sector_ids => []}}
    columns.each_with_index do |key, index|
      add_data(params, key, row[index])
    end
    user = User.new(params)
    user.password = String.password
    case(params[:role_id])
    when(5) #Expositor
      user.preference = Preference.general_for_exhibitor.first
    when(3) #Comprador nacional
      user.preference = Preference.general_for_national_buyer.first
    when(4) #Comprador internacional
      user.preference = Preference.general_for_international_buyer.first
    end
    if DEBUG
      puts params.to_yaml
      puts "VALIDO: " + user.valid?
      raise Exception.new("Couldn't validate: #{user.errors.to_yaml}") unless user.valid?
    elsif !user.save
      raise Exception.new("Couldn't save: #{user.errors.to_yaml}")
    else
      puts "guardado!"
    end
  end

  def add_data(user, key, value)
    value = value.blank? ? '' : value.strip[1..-2]
    key = key.upcase
    case key
    when "EMPRESA"
      user[:profile_attributes][:company_name] = value
    when "LOGIN"
      user[:login] = value.downcase
    when "PAIS"
      user[:profile_attributes][:country_id] = country_id_of(value)
    when "PERFIL"
      user[:profile_attributes][:commercial_profile] = value
    when "WEB"
      user[:profile_attributes][:website] = value
    when "DIRECCION"
      user[:profile_attributes][:address] = value
    when "CP"
      user[:profile_attributes][:zip_code] = value.to_i
    when "LOCALIDAD"
      user
    when "PROVINCIA"
      user
    when "TELEFONO"
      user[:profile_attributes][:phone] = value
    when "FAX"
      user[:profile_attributes][:fax] = value
    when "EMAIL"
      user[:email] = value.strip
      user[:login] = value.split('@')[0].downcase
    when "IDIOMAS"
      user[:profile_attributes][:languages] = value
    when "PERSONA DE CONTACTO"
      user[:profile_attributes][:commercial_profile] = value

    when "CARGO"
      user[:profile_attributes][:commercial_profile] = value + ": " + user[:profile_attributes][:commercial_profile]
    else
      add_category(user, key, value)
    end
    
  end

  def country_id_of(value)
    value = "ESTADOSUNIDOS" if value == "USA"
    value = "REINOUNIDO" if value == "REINO UNIDO"
    id = PAISES[value]
    raise Exception.new("Pais #{value} no encontrado #{PAISES_NOMBRES}") if id.blank?
    id
  end

  
  def add_category(user, key, value)
    key = CAT_SUS[key] if CAT_SUS[key].present?

    if value.present?
      id = SECTORES[key]
      raise Exception.new("Sector '#{key}' no encontrado '#{SECTORES_NOMBRES}'") if id.blank?
      user[:profile_attributes][:sector_ids] << id
    end
  end

end

DEBUG = true
Importer.new(:expositor, "db/import/expositores.csv", EXPOSITORES)