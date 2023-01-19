use ExtUtils::MakeMaker;
WriteMakefile(
    NAME => '',
    VERSION_FROM => 'lib/VM/EC2/Instance/Metadata/V2.pm',
    ABSTRACT => 'Supports IMDSV2',
    PREREQ_PM => {
        'VM::EC2' => '0',
    }
);
