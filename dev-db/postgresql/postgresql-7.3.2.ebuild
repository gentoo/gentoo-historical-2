# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgresql/postgresql-7.3.2.ebuild,v 1.6 2003/03/23 18:03:39 nakano Exp $

DESCRIPTION="sophisticated Object-Relational DBMS"
SRC_URI="ftp://ftp.us.postgresql.org/source/v${PV}/${P}.tar.gz"
HOMEPAGE="http://www.postgresql.org/"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"
IUSE="ssl nls java python tcltk perl libg++"

filter-flags -ffast-math 

DEPEND="virtual/glibc
	sys-devel/autoconf
	app-admin/sudo
	>=sys-libs/readline-4.1
	>=sys-libs/ncurses-5.2
	>=sys-libs/zlib-1.1.3
	tcltk? ( >=dev-lang/tcl-8 >=dev-lang/tk-8.3.3-r1 )
	perl? ( >=dev-lang/perl-5.6.1-r2 )
	python? ( >=dev-lang/python-2.2 dev-python/egenix-mx-base )
	java? ( >=virtual/jdk-1.3* >=dev-java/ant-1.3 )
	ssl? ( >=dev-libs/openssl-0.9.6-r1 )
	nls? ( sys-devel/gettext )"
# java dep workaround for portage bug
# x86? ( java? ( =dev-java/sun-jdk-1.3* >=dev-java/ant-1.3 ) )
RDEPEND="virtual/glibc
	>=sys-libs/zlib-1.1.3
	tcltk? ( >=dev-lang/tcl-8 )
	perl? ( >=dev-lang/perl-5.6.1-r2 )
	python? ( >=dev-lang/python-2.2 )
	java? ( >=virtual/jdk-1.3* )
	ssl? ( >=dev-libs/openssl-0.9.6-r1 )"

PG_DIR="/var/lib/postgresql"

pkg_setup() {
	if [ -f ${PG_DIR}/data/PG_VERSION ] ; then
		PG_MAJOR=`cat ${PG_DIR}/data/PG_VERSION | cut -f1 -d.`
		PG_MINOR=`cat ${PG_DIR}/data/PG_VERSION | cut -f2 -d.`
		if [ ${PG_MAJOR} -lt 7 ] || [ ${PG_MAJOR} -eq 7 -a ${PG_MINOR} -lt 3 ] ; then
			eerror "Postgres ${PV} cannot upgrade your existing databases, you must"
			eerror "use pg_dump to export your existing databases to a file, and then"
			eerror "pg_restore to import them when you have upgraded completely."
			eerror "You must remove your entire database directory to continue."
			eerror "(database directory = ${PG_DIR})."
			exit 1
		fi
	fi
}

src_compile() {
	local myconf
	use tcltk && myconf="--with-tcl"
	use python && myconf="$myconf --with-python"
	use perl && myconf="$myconf --with-perl"
	use java && myconf="$myconf --with-java"
	use ssl && myconf="$myconf --with-openssl"
	use nls && myconf="$myconf --enable-locale --enable-nls --enable-multibyte"
	use libg++ && myconf="$myconf --with-CXX"

	# these are the only working CFLAGS I could get on ppc, so locking them
        # down, anything more aggressive fails (i.e. -mcpu or -Ox)
	# Gerk - Nov 26, 2002
	use ppc && CFLAGS="-pipe -fsigned-char"

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

	make || die
	cd contrib
	make || die
}

src_install() {
	addwrite "/usr/share/man/man3/Pg.3pm"

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
	cd ${S}/contrib
	make DESTDIR=${D} LIBDIR=${D}/usr/lib install || die
	cd ${S}
	dodoc COPYRIGHT HISTORY INSTALL README register.txt
	dodoc contrib/adddepend/*
	cd ${S}/doc
	dodoc FAQ* KNOWN_BUGS MISSING_FEATURES README*
	dodoc TODO bug.template
	docinto sgml
	dodoc src/sgml/*.{sgml,dsl}
	docinto sgml/ref
	dodoc src/sgml/ref/*.sgml
	docinto sgml/graphics
	dodoc src/graphics/*
	rm -rf ${D}/usr/doc ${D}/mnt
	exeinto /usr/bin

	if [ `use java` ]; then
		dojar ${D}/usr/share/postgresql/java/postgresql.jar
		rm ${D}/usr/share/postgresql/java/postgresql.jar
	fi

	dodir /usr/include/postgresql/pgsql
	cp ${D}/usr/include/*.h ${D}/usr/include/postgresql/pgsql

	exeinto /etc/init.d/
	doexe ${FILESDIR}/${PV}/${PN} || die

	exeinto /etc/conf.d/
	doexe ${FILESDIR}/postgresql || die
}

pkg_postinst() {
	einfo ">>> Execute the following command"
	einfo ">>> ebuild  /var/db/pkg/dev-db/${PF}/${PF}.ebuild config"
	einfo ">>> to setup the initial database environment."
	einfo ">>> "
	einfo ">>> Make sure the postgres user in /etc/passwd has an account setup with /bin/bash as the shell, or /bin/true"
}

pkg_config() {
	einfo ">>> Creating data directory ..."
	mkdir -p ${PG_DIR}/data
	chown -Rf postgres.postgres ${PG_DIR}
	chmod 700 ${PG_DIR}/data

	einfo ">>> Initializing the database ..."
	if [ -f ${PG_DIR}/data/PG_VERSION ] ; then
		PG_MAJOR=`cat ${PG_DIR}/data/PG_VERSION | cut -f1 -d.`
		PG_MINOR=`cat ${PG_DIR}/data/PG_VERSION | cut -f2 -d.`
		if [ ${PG_MAJOR} -lt 7 ] || [ ${PG_MAJOR} -eq 7 -a ${PG_MINOR} -lt 3 ] ; then
			eerror "Postgres ${PV} cannot upgrade your existing databases."
			eerror "You must remove your entire database directory to continue."
			eerror "(database directory = ${PG_DIR})."
			exit 1
		else
			einfo -n "A postgres data directory already exists from version "; cat ${PG_DIR}/data/PG_VERSION
			einfo "Read the documentation to check how to upgrade to version ${PV}."
		fi
	else
		sudo -u postgres /usr/bin/initdb --pgdata ${PG_DIR}/data
		einfo "If you are upgrading from a pre-7.3 version of PostgreSQL, please read"
		einfo "the README.adddepend file for information on how to properly migrate"
		einfo "all serial columns, unique keys and foreign keys to this version."
	fi
}
