

class Phone
{
  number: string;
  constructor(num: string) { this.number = num }
}

var phone = (num) => new Phone(num);

class Person
{
  id: number;
  name: string;
  phones: Phone[];
  constructor(i: number, n: string, ps: Phone[]) { this.id = i; this.name = n; this.phones = ps }
}


interface API
{
  person_list: () => Person[];
  create_person: (Person) => Person;
  delete_person: (Person) => void;
  update_person: (Person) => void;
}



class HeadlessAPI implements API
{
  data = [ new Person(0,'Dr Robert', [ phone('000'), phone('111-222-333') ]),
	   new Person(1,'Ms Z', [ phone('+7 (908) 36-77-123') ]) ];
			  
  person_list() { return this.data }
  create_person(p: Person) { return p }
  delete_person(p) { }
  update_person(p) { }

}


class AjaxAPI implements API
{
  constructor {
    $.ajaxSetup({ contentType: 'application/json, charset=utf-8',
		  dataType: 'json',
		  processData: false,
		  async: false });
  }

  req(meth: String, id: String, data?: any): any {
    var url = '/api/people/' + id;
    var opts = <JQueryAjaxSettings> { type: meth };
    if (data) opts.data = JSON.stringify(data);
    var req = $.ajax(url, opts);
    return $.parseJSON(req.responseText);
  }

  person_list() {
    console.log('api list');
    return <Person[]> this.req('GET', '*');
  }

  create_person(p: Person) {
    console.log('api add', p);
    return <Person> this.req('POST', '_', p);
  }

  delete_person(p: Person) {
    console.log('api del', p);
    this.req('DELETE', p.id.toString());
  }
  
  update_person(p: Person) {
    console.log('api upd', p);
    this.req('PUT', p.id.toString(), p);
  }

}



