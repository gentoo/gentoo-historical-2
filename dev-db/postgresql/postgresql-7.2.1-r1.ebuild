# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# /space/gentoo/cvsroot/gentoo-x86/dev-db/postgresql/postgresql-7.2.1.ebuild,v 1.2 2002/06/17 04:05:39 rphillips Exp

S=${WORKDIR}/${P}
DESCRIPTION="PostgreSQL is a sophisticated Object-Relational DBMS"
SRC_URI="ftp://ftp.easynet.be/postgresql/v${PV}/${P}.tar.gz"
HOMEPAGE="http://www.postgresql.org"
LICENSE="POSTGRESQL"

DEPEND="virtual/glibc
		sys-devel/autoconf
		>=sys-libs/readline-4.1
		>=sys-libs/ncurses-5.2
		>=sys-libs/zlib-1.1.3
		tcltk? ( >=dev-lang/tcl-8 )
		perl? ( >=sys-devel/perl-5.6.1-r2 )
		python? ( >=dev-lang/python-2.2 )
		java? ( =virtual/jdk-1.3* >=dev-java/ant-1.3 )
		ssl? ( >=dev-libs/openssl-0.9.6-r1 )
		nls? ( sys-devel/gettext )"

RDEPEND="virtual/glibc
		>=sys-libs/zlib-1.1.3
		tcltk? ( >=dev-lang/tcl-8 )
		perl? ( >=sys-devel/perl-5.6.1-r2 )
		python? ( >=dev-lang/python-2.2 )
		java? ( =virtual/jdk-1.3* )
		ssl? ( >=dev-libs/openssl-0.9.6-r1 )"

SLOT="0"

pkg_setup() {
	local foo
	if [ "`use java`" ] ; then
		foo=`java-config --java-version 2>&1 | grep "1.4.0"`
		if [ ! -z "$foo" ] ; then
			einfo "Cannot build with Sun JDK 1.4.0, use any of the 1.3.x JDKs instead."
			exit 1
		fi
	fi
}

src_unpack() {

	unpack postgresql-${PV}.tar.gz

	cd ${S}

	# we know that a shared libperl is present, the default perl
	# config is however set to the static libperl.a
	# just remove the check
	patch -p1 < ${FILESDIR}/${P}-dyn-libperl-gentoo.diff || die
	cp ${FILESDIR}/${P}-build.xml ${S}/src/interfaces/jdbc/build.xml
}

src_compile() {

	local myconf
	if [ "`use tcltk`" ]
	then
		myconf="--with-tcl"
	fi
	if [ "`use python`" ]
	then
		myconf="$myconf --with-python"
	fi
	if [ "`use perl`" ]
	then
		myconf="$myconf --with-perl"
	fi
	if [ "`use java`" ]
	then
		myconf="$myconf --with-java"
	fi
	if [ "`use ssl`" ]
	then
		myconf="$myconf --with-openssl=yes"
	fi
	if [ "`use nls`" ]
	then
		myconf="$myconf --enable-locale --enable-nls"
	fi
	if [ "`use libg++`" ]
	then
	myconf="$myconf --with-CXX"
	fi

	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--host=${CHOST} \
		--docdir=/usr/share/doc/${P} \
		--libdir=/usr/lib \
		--enable-syslog \
		--enable-depend \
		--with-gnu-ld \
		--with-pam \
		--with-maxbackends=1024 \
		$myconf || die

	emake || die

}

pkg_preinst() {
	if ! groupmod postgresql ; then
		groupadd -g 70 postgres || die "problem adding group postgres"
	fi

	if ! id postgresql; then
		useradd -g postgres -s /dev/null -d /var/lib/postgresql -c "postgres" postgres
		assert "problem adding user postgres"
	fi
}

src_install () {

	if [ "`use perl`" ]
	then
		mv ${S}/src/pl/plperl/Makefile ${S}/src/pl/plperl/Makefile_orig
		sed -e "s:(INST_DYNAMIC) /usr/lib:(INST_DYNAMIC) ${D}/usr/lib:" \
			${S}/src/pl/plperl/Makefile_orig > ${S}/src/pl/plperl/Makefile
		mv ${S}/src/pl/plperl/GNUmakefile ${S}/src/pl/plperl/GNUmakefile_orig
		sed -e "s:\$(DESTDIR)\$(plperl_installdir):\$(plperl_installdir):" \
			${S}/src/pl/plperl/GNUmakefile_orig > ${S}/src/pl/plperl/GNUmakefile
	fi

	make DESTDIR=${D} LIBDIR=${D}/usr/lib install || die
	make DESTDIR=${D} install-all-headers || die
	dodoc COPYRIGHT HISTORY INSTALL README register.txt
	cd ${S}/doc
	dodoc FAQ* KNOWN_BUGS MISSING_FEATURES README*
	dodoc TODO internals.ps bug.template
	dodoc *.tar.gz
	docinto sgml
	dodoc src/sgml/*.{sgml,dsl}
	docinto sgml/ref
	dodoc src/sgml/ref/*.sgml
	docinto sgml/graphics
	dodoc src/graphics/*
	rm -rf ${D}/usr/doc ${D}/mnt
	exeinto /usr/bin
	
	dojar ${D}/usr/share/postgresql/java/postgresql.jar
	rm ${D}/usr/share/postgresql/java/postgresql.jar

	dodir ${D}/usr/include/postgresql/pgsql
	ln -s ${D}/usr/include/*.h ${D}/usr/include/postgresql/pgsql

	exeinto /etc/init.d/
	doexe ${FILESDIR}/${PV}/${PN}

	einfo ">>> Execute the following command"
	einfo ">>> ebuild  /var/db/pkg/dev-db/${P}/${P}.ebuild config"
	einfo ">>> to setup the initial database environment."
}


pkg_config() {

	einfo ">>> Creating data directory ..."
	mkdir -p /var/lib/postgresql/data
	chown -Rf postgres.postgres /var/lib/postgresql
	chmod 700 /var/lib/postgresql/data

	einfo ">>> Initializing the database ..."
	if [ -f /var/lib/postgresql/data/PG_VERSION ] ; then
		echo -n "A postgres data directory already exists from version "; cat /var/lib/postgresql/data/PG_VERSION
		echo "Read the documentation to check how to upgrade to version ${PV}."
	else
		su - postgres -c "/usr/bin/initdb --pgdata /var/lib/postgresql/data"
	fi

}
