/// <reference path="jquery.d.ts" />
/// <reference path="knockout.d.ts" />
/// <reference path="knockout.mapping.d.ts" />
/// <reference path="core.ts" />


declare var phone: (string) => any;

var api;

class Info
{
  newPhone = ko.observable(phone(''));

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

    this.addPhone = (_: Phone) => {
      view.currentPerson().phones.push(this.newPhone());
      this.newPhone('');
    }

    this.editDone = (p) => {
      api.update_person(p); 
      view.sync();
      view.select(p);
      console.log('done?');
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

  sync () { console.log('sync'); ko.mapping.fromJS(api.person_list(), this.people); }


  constructor
  {
    console.log(api.person_list());

    this.select = (p) => {
      var editable = ko.mapping.toJS(p);
      this.currentPerson(ko.mapping.fromJS(editable));
      this.info = new Info(this);
    };

    this.addPerson = (p) => {
    }

    this.delPerson = (p) => {
      console.log('del', p);
      api.delete_person(p.id);
    }

    if (this.people().length > 0)
      this.select(this.people()[0]);
  }
}


class UI
{
  constructor
  {
    api = new AjaxAPI();
    console.log('~', api.person_list());
    ko.applyBindings(new View());
  }
}


$(() => new UI());

