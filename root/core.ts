


class Phone
{
  number: string;
  constructor(num: string) { this.number = num }
}

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



var a: {[id:number]: Person;};

a['2'+'a']=3;



class HeadlessAPI implements API
{
  data = [ new Person('0','Dr Robert', [ new Phone('000'), new Phone('111-222-333') ]),
	   new Person('1','Ms Z', [ new Phone('+7 (908) 36-77-123') ]) ];
			  
  person_list() { return this.data }


}


