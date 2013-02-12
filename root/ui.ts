/// <reference path="jquery.d.ts" />
/// <reference path="knockout.d.ts" />
/// <reference path="knockout.mapping.d.ts" />
/// <reference path="core.ts" />



var api = new AjaxAPI();

class Info
{
  newPhone = ko.mapping.fromJS(new Phone(''));

  changeState: () => void;
  state = ko.observable('view');
  goEdit: () => void;
  delPhone;
  addPhone;
  editDone;

  constructor (view) {

    this.goEdit = () => {
      this.state('edit');
    }

    this.delPhone = (p: Phone) => {
      view.currentPerson().phones.remove(p);
    }

    this.addPhone = (p: Phone) => {
      view.currentPerson().phones.push(ko.mapping.toJS(p));
      this.newPhone.number('');
    }

    this.editDone = (p) => {
      console.log(p.id(), p.name());
      //xxx update
      this.state('view');
    };
  }
}

class View
{
  people = ko.mapping.fromJS(api.person_list());
  currentPerson = ko.observable();

  select;
  addPerson;
  delPerson;

  info: Info;


  constructor
  {
    this.info = new Info(this);

    this.select = (p) => {
      var editable = ko.mapping.toJS(p);
      this.currentPerson(ko.mapping.fromJS(editable));
    };

    this.addPerson = (p) => {
    }

    this.delPerson = (p) => {
      console.log('del', p);
      api.deletePerson(p.id);
    }

    if (this.people().length > 0)
      this.select(this.people()[0]);
  }
}


class UI
{
  constructor
  {
    ko.applyBindings(new View());
  }
}


$(() => new UI());

