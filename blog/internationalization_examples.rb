Isy::Internationalization.default_locale = :cs

class MyApp
  dt.name 'jméno'
end

module Models
  class Person
    # .dt is aliased .define_translation
    dt.human_name 'Osoba'
    dt.attributes do
      first_name 'křestní jméno'
      sure_name 'příjmení'
      name MyApp.t.name # a generic translation shared in application
    end

  end

  class User < Person
    dt.human_name = 'Uživatel'
    dt.attributes do
      login 'login'
      pssword 'heslo'
    end
  end
end

Person.t.human_name # => 'Osoba'
User.t.human_name # => 'Uživatel'
User.t.first_name # => 'křestní jméno'
User.t.name # => 'jméno'

