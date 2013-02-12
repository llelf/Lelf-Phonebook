var api = new AjaxAPI();
var Info = (function () {
    function Info(view) {
        var _this = this;
        this.newPhone = ko.mapping.fromJS(new Phone(''));
        this.state = ko.observable('view');
        this.goEdit = function () {
            _this.state('edit');
        };
        this.delPhone = function (p) {
            view.currentPerson().phones.remove(p);
        };
        this.addPhone = function (p) {
            view.currentPerson().phones.push(ko.mapping.toJS(p));
            _this.newPhone.number('');
        };
        this.editDone = function (p) {
            console.log(p.id(), p.name());
            _this.state('view');
        };
    }
    return Info;
})();
var View = (function () {
    function View() {
        var _this = this;
        this.people = ko.mapping.fromJS(api.person_list());
        this.currentPerson = ko.observable();
        this.info = new Info(this);
        this.select = function (p) {
            var editable = ko.mapping.toJS(p);
            _this.currentPerson(ko.mapping.fromJS(editable));
        };
        this.addPerson = function (p) {
        };
        this.delPerson = function (p) {
            console.log('del', p);
            api.deletePerson(p.id);
        };
        if(this.people().length > 0) {
            this.select(this.people()[0]);
        }
    }
    return View;
})();
var UI = (function () {
    function UI() {
        ko.applyBindings(new View());
    }
    return UI;
})();
$(function () {
    return new UI();
});
