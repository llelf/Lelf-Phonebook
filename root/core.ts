


class Phone
{
  number: string;
  constructor(num: string) { this.number = num }
}

phone = (num) => new Phone(num);

class Person
{
  id: string;
  name: string;
  phones: Phone[];
  constructor(i: string, n: string, ps: Phone[]) { this.id = i; this.name = n; this.phones = ps }
}


interface API
{
  person_list: () => Person[];
  add_person: (Person) => Person;
  delete_person: (Person) => void;
  update_person: (Person) => void;
}



class HeadlessAPI implements API
{
  data = [ new Person('0','Dr Robert', [ phone('000'), phone('111-222-333') ]),
	   new Person('1','Ms Z', [ phone('+7 (908) 36-77-123') ]) ];
			  
  person_list() { return this.data }
  add_person(p: Person) { return p }
  delete_person(p) { }
  update_person(p) { }

}

class Data { data: Person[]; };

// class Req {
//   data: any;
//   constructor
// }

class AjaxAPI implements API
{
  constructor {
    $.ajaxSetup({ contentType: 'application/json',
		  dataType: 'json',
		  processData: false,
		  async: false });
  }

  req(url, meth, data?): any {
    console.log('data', data, JSON.stringify(data));
    var req = $.ajax(url, { type: meth, data: JSON.stringify(data) });
    var ps = $.parseJSON(req.responseText);
    return ps;
  }

  person_list() {
    return <Person[]> this.req('/api/people/*', 'GET');
  }

  add_person(p: Person) { return p }
  delete_person(p) { }
  update_person(p) {
    this.req('/api/people/' + p.id(), 'PUT', ko.mapping.toJS(p));
  }

}



