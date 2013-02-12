var Phone = (function () {
    function Phone(num) {
        this.number = num;
    }
    return Phone;
})();
var Person = (function () {
    function Person(i, n, ps) {
        this.id = i;
        this.name = n;
        this.phones = ps;
    }
    return Person;
})();
var a;
a['2' + 'a'] = 3;
var HeadlessAPI = (function () {
    function HeadlessAPI() {
        this.data = [
            new Person('0', 'Dr Robert', [
                new Phone('000'), 
                new Phone('111-222-333')
            ]), 
            new Person('1', 'Ms Z', [
                new Phone('+7 (908) 36-77-123')
            ])
        ];
    }
    HeadlessAPI.prototype.person_list = function () {
        return this.data;
    };
    return HeadlessAPI;
})();
