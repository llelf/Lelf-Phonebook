/// <reference path="jquery.d.ts" />
/// <reference path="knockout.d.ts" />
/// <reference path="knockout.mapping.d.ts" />
/// <reference path="core.ts" />

declare var phone: (string) => any;
var ui;
var api;

class Info
{
  newPhone = ko.mapping.fromJS(phone(''));

  changeState: () => void;
  state = ko.observable('?');
  goEdit: () => void;
  delPhone;
  addPhone;
  editDone;

  constructor (view) {
    this.goEdit = () => { this.state('edit') };

    this.delPhone = (p: Phone) => {
      view.currentPerson.phones.remove(p);
    }

    this.addPhone = (_: Phone) => {
      view.currentPerson.phones.push(ko.toJS(this.newPhone));
      this.newPhone.number('');
    }

    this.editDone = (p) => {
      api.update_person(ko.mapping.toJS(p));
      view.sync();
      view.select(p);
    };
  }
}

class View
{
  people = ko.mapping.fromJS(api.person_list());
  currentPerson = ko.mapping.fromJS(new Person(-1,'',[]));
  newPerson = ko.mapping.fromJS(new Person(-1,'',[]));

  select;
  addPerson;
  delPerson;

  info: Info;

  sync () {
    console.log('sync');
    ko.mapping.fromJS(api.person_list(), this.people);
  }

  selectFirst () {
    if (this.people().length > 0)
      this.select(this.people()[0]);
  }

  constructor
  {
    this.info = new Info(this);

    this.select = (p) => {
      var editable = ko.mapping.toJS(p);
      ko.mapping.fromJS(editable, this.currentPerson);
      this.info.state('view');
    };

    this.addPerson = (p) => {
      var np = api.create_person(ko.mapping.toJS(p));
      p.name('');
      this.sync();
      this.select(ko.mapping.fromJS(np));
    }

    this.delPerson = (p) => {
      api.delete_person(ko.mapping.toJS(p));
      this.info.state('?');
      this.sync();
      this.selectFirst();
    }

    this.selectFirst();
  }
}


class UI
{
  constructor
  {
    api = new AjaxAPI();
    ko.applyBindings(view = new View());
  }
}


var view: View;

$(() => { new UI() });

