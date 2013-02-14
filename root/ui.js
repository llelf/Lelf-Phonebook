var ui;
var api;
var Info = (function () {
    function Info(view) {
        var _this = this;
        this.newPhone = ko.observable(phone(''));
        this.state = ko.observable('?');
        this.goEdit = function () {
            _this.state('edit');
        };
        this.delPhone = function (p) {
            view.currentPerson.phones.remove(p);
        };
        this.addPhone = function (_) {
            view.currentPerson.phones.push(_this.newPhone());
            _this.newPhone(phone(''));
        };
        this.editDone = function (p) {
            api.update_person(ko.mapping.toJS(p));
            view.sync();
            view.select(p);
        };
    }
    return Info;
})();
var View = (function () {
    function View() {
        var _this = this;
        this.people = ko.mapping.fromJS(api.person_list());
        this.currentPerson = ko.mapping.fromJS(new Person(-1, '', []));
        this.newPerson = ko.mapping.fromJS(new Person(-1, '', []));
        this.info = new Info(this);
        this.select = function (p) {
            var editable = ko.mapping.toJS(p);
            ko.mapping.fromJS(editable, _this.currentPerson);
            _this.info.state('view');
        };
        this.addPerson = function (p) {
            var np = api.create_person(ko.mapping.toJS(p));
            p.name('');
            _this.sync();
            _this.select(ko.mapping.fromJS(np));
        };
        this.delPerson = function (p) {
            api.delete_person(ko.mapping.toJS(p));
            _this.info.state('?');
            _this.sync();
            _this.selectFirst();
        };
        this.selectFirst();
    }
    View.prototype.sync = function () {
        console.log('sync');
        ko.mapping.fromJS(api.person_list(), this.people);
    };
    View.prototype.selectFirst = function () {
        if(this.people().length > 0) {
            this.select(this.people()[0]);
        }
    };
    return View;
})();
var UI = (function () {
    function UI() {
        api = new AjaxAPI();
        ko.applyBindings(view = new View());
    }
    return UI;
})();
var view;
$(function () {
    new UI();
});
