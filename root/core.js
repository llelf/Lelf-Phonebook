var Phone = (function () {
    function Phone(num) {
        this.number = num;
    }
    return Phone;
})();
phone = function (num) {
    return new Phone(num);
};
var Person = (function () {
    function Person(i, n, ps) {
        this.id = i;
        this.name = n;
        this.phones = ps;
    }
    return Person;
})();
var HeadlessAPI = (function () {
    function HeadlessAPI() {
        this.data = [
            new Person('0', 'Dr Robert', [
                phone('000'), 
                phone('111-222-333')
            ]), 
            new Person('1', 'Ms Z', [
                phone('+7 (908) 36-77-123')
            ])
        ];
    }
    HeadlessAPI.prototype.person_list = function () {
        return this.data;
    };
    HeadlessAPI.prototype.add_person = function (p) {
        return p;
    };
    HeadlessAPI.prototype.delete_person = function (p) {
    };
    HeadlessAPI.prototype.update_person = function (p) {
    };
    return HeadlessAPI;
})();
var Data = (function () {
    function Data() { }
    return Data;
})();
;
var AjaxAPI = (function () {
    function AjaxAPI() {
        $.ajaxSetup({
            contentType: 'application/json',
            dataType: 'json',
            processData: false,
            async: false
        });
    }
    AjaxAPI.prototype.req = function (url, meth, data) {
        console.log('data', data, JSON.stringify(data));
        var req = $.ajax(url, {
            type: meth,
            data: JSON.stringify(data)
        });
        var ps = $.parseJSON(req.responseText);
        return ps;
    };
    AjaxAPI.prototype.person_list = function () {
        return this.req('/api/people/*', 'GET');
    };
    AjaxAPI.prototype.add_person = function (p) {
        return p;
    };
    AjaxAPI.prototype.delete_person = function (p) {
    };
    AjaxAPI.prototype.update_person = function (p) {
        this.req('/api/people/' + p.id(), 'PUT', ko.mapping.toJS(p));
    };
    return AjaxAPI;
})();
