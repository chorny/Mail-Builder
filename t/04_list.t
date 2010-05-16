# -*- perl -*-

# t/004_address.t - check module for address handling

use Test::Most tests => 37 + 1;
use Test::NoWarnings;

use Mail::Builder;

# List1
ok($list1 = Mail::Builder::List->new(type => 'Mail::Builder::Address'),'Create list');
isa_ok ($list1, 'Mail::Builder::List');
is($list1->type, 'Mail::Builder::Address');
is($list1->length, 0);

ok($list1->add('test@test.com'), 'Add new item');
is($list1->length, 1);

ok($list1->add('test2@test2.com','test2'), 'Add new item');

is($list1->length, 2);

ok($list1->add({ email => 'test3@test3.com' }), 'Add new item');
is($list1->length, 3);

my $address1 = Mail::Builder::Address->new( email => 'test4@test4.com' );
ok($list1->add($address1), 'Add new item');
is($list1->length, 4);

isa_ok(scalar($list1->list),'ARRAY');
isa_ok($list1->item(0),'Mail::Builder::Address');

is($list1->item(0)->email,'test@test.com','Address 1 email');
is($list1->item(1)->email,'test2@test2.com','Address 2 email');
is($list1->item(1)->name,'test2','Address 2 name');
is($list1->item(2)->email,'test3@test3.com','Address 3 email');
is($list1->item(3)->email,'test4@test4.com','Address 4 email');


is($list1->join(', '),'test@test.com, "test2" <test2@test2.com>, test3@test3.com, test4@test4.com','Join ok');

is($list1->contains($address1),1,'Has item');
is($list1->contains('test@test.com'),1,'Has item');
is($list1->contains('test5@test5.com'),0,'Has no item');

my $address2 = Mail::Builder::Address->new('test3@test3.com','test3');
$list1->add($address2);

is($list1->length, 4);

$list1->remove('test@test.com');
is($list1->length, 3);
is($list1->contains('test@test.com'),0,'Has not item');

$list1->remove(1);
is($list1->length, 2);
is($list1->contains('test3@test3.com'),0,'Has not item');

$list1->remove();
is($list1->length, 1);

ok($list1->reset,'Reset list');
is($list1->length, 0);

$list1->add($address2);
is($list1->length, 1);

is($list1->item(0)->email,$address2->email);

my $fake_object = bless {},'Fake';
throws_ok {
    $list1->add($fake_object);
} qr/Invalid item added to list/;

ok($list2 = Mail::Builder::List->convert([$address1,$address2]),'Convert item');
is($list2->item(0)->email, 'test4@test4.com');
is($list2->length, 2);