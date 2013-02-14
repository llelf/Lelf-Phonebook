var api;
var Info = (function () {
    function Info(view) {
        var _this = this;
        this.newPhone = ko.observable(phone(''));
        this.state = ko.observable('view');
        this.goEdit = function () {
            _this.state('edit');
        };
        this.delPhone = function (p) {
            view.currentPerson().phones.remove(p);
        };
        this.addPhone = function (_) {
            view.currentPerson().phones.push(_this.newPhone());
            _this.newPhone('');
        };
        this.editDone = function (p) {
            api.update_person(p);
            view.sync();
            view.select(p);
            console.log('done?');
        };
    }
    return Info;
})();
var View = (function () {
    function View() {
        var _this = this;
        this.people = ko.mapping.fromJS(api.person_list());
        this.currentPerson = ko.observable();
        console.log(api.person_list());
        this.select = function (p) {
            var editable = ko.mapping.toJS(p);
            _this.currentPerson(ko.mapping.fromJS(editable));
            _this.info = new Info(_this);
        };
        this.addPerson = function (p) {
        };
        this.delPerson = function (p) {
            console.log('del', p);
            api.delete_person(p.id);
        };
        if(this.people().length > 0) {
            this.select(this.people()[0]);
        }
    }
    View.prototype.sync = function () {
        console.log('sync');
        ko.mapping.fromJS(api.person_list(), this.people);
    };
    return View;
})();
var UI = (function () {
    function UI() {
        api = new AjaxAPI();
        console.log('~', api.person_list());
        ko.applyBindings(new View());
    }
    return UI;
})();
$(function () {
    return new UI();
});
