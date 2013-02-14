var Phone = (function () {
    function Phone(num) {
        this.number = num;
    }
    return Phone;
})();
var phone = function (num) {
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
            new Person(0, 'Dr Robert', [
                phone('000'), 
                phone('111-222-333')
            ]), 
            new Person(1, 'Ms Z', [
                phone('+7 (908) 36-77-123')
            ])
        ];
    }
    HeadlessAPI.prototype.person_list = function () {
        return this.data;
    };
    HeadlessAPI.prototype.create_person = function (p) {
        return p;
    };
    HeadlessAPI.prototype.delete_person = function (p) {
    };
    HeadlessAPI.prototype.update_person = function (p) {
    };
    return HeadlessAPI;
})();
var AjaxAPI = (function () {
    function AjaxAPI() {
        $.ajaxSetup({
            contentType: 'application/json',
            dataType: 'json',
            processData: false,
            async: false
        });
    }
    AjaxAPI.prototype.req = function (meth, id, data) {
        var url = '/api/people/' + id;
        var opts = {
            type: meth
        };
        if(data) {
            opts.data = JSON.stringify(data);
        }
        var req = $.ajax(url, opts);
        return $.parseJSON(req.responseText);
    };
    AjaxAPI.prototype.person_list = function () {
        console.log('api list');
        return this.req('GET', '*');
    };
    AjaxAPI.prototype.create_person = function (p) {
        console.log('api add', p);
        return this.req('POST', '_', p);
    };
    AjaxAPI.prototype.delete_person = function (p) {
        console.log('api del', p);
        this.req('DELETE', p.id.toString());
    };
    AjaxAPI.prototype.update_person = function (p) {
        console.log('api upd', p);
        this.req('PUT', p.id.toString(), p);
    };
    return AjaxAPI;
})();
