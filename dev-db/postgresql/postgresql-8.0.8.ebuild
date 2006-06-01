# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgresql/postgresql-8.0.8.ebuild,v 1.5 2006/06/01 19:59:34 gustavoz Exp $

inherit eutils gnuconfig flag-o-matic multilib toolchain-funcs

DESCRIPTION="sophisticated Object-Relational DBMS."
HOMEPAGE="http://www.postgresql.org/"
P_HIERPG="hier-Pg8.0.1-0.5.4"
MY_PV=${PV/_/}
MY_P=${PN}-${MY_PV}
SRC_URI="mirror://postgresql/source/v${PV}/${PN}-base-${MY_PV}.tar.bz2
	mirror://postgresql/source/v${PV}/${PN}-opt-${MY_PV}.tar.bz2
	doc? ( mirror://postgresql/source/v${PV}/${PN}-docs-${MY_PV}.tar.bz2 )
	pg-hier? ( http://gppl.moonbone.ru/${P_HIERPG}.diff.gz )"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 mips ppc ppc64 ~s390 ~sh sparc ~x86"
IUSE="ssl nls python tcltk perl libg++ pam readline xml2 zlib doc selinux kerberos pg-intdatetime pg-hier"

S=${WORKDIR}/${MY_P}
DEPEND="virtual/libc
	=dev-db/libpq-8.0.8*
	sys-devel/autoconf
	>=sys-libs/ncurses-5.2
	>=sys-devel/bison-1.875
	zlib? ( >=sys-libs/zlib-1.1.3 )
	readline? ( >=sys-libs/readline-4.1 )
	tcltk? ( >=dev-lang/tcl-8 >=dev-lang/tk-8.3.3-r1 )
	perl? ( >=dev-lang/perl-5.6.1-r2 )
	python? ( >=dev-lang/python-2.2 dev-python/egenix-mx-base )
	ssl? ( >=dev-libs/openssl-0.9.6-r1 )
	xml2? ( dev-libs/libxml2 dev-libs/libxslt dev-util/pkgconfig )
	nls? ( sys-devel/gettext )
	kerberos? ( virtual/krb5 )"
RDEPEND="virtual/libc
	=dev-db/libpq-8.0.8*
	zlib? ( >=sys-libs/zlib-1.1.3 )
	tcltk? ( >=dev-lang/tcl-8 )
	perl? ( >=dev-lang/perl-5.6.1-r2 )
	python? ( >=dev-lang/python-2.2 )
	selinux? ( sec-policy/selinux-postgresql )
	ssl? ( >=dev-libs/openssl-0.9.6-r1 )
	xml2? ( dev-libs/libxml2 dev-libs/libxslt )
	kerberos? ( virtual/krb5 )"

PG_DIR="/var/lib/postgresql"

# misc files
FILES_VER="8.0.7"

pkg_setup() {
	if [ -f ${PG_DIR}/data/PG_VERSION ] ; then
		PG_MAJOR=`cat ${PG_DIR}/data/PG_VERSION | cut -f1 -d.`
		PG_MINOR=`cat ${PG_DIR}/data/PG_VERSION | cut -f2 -d.`
		if [ ${PG_MAJOR} -lt 8 ] || [ ${PG_MAJOR} -eq 8 -a ${PG_MINOR} -lt 0 ] ; then
			eerror "Postgres ${MY_PV} cannot upgrade your existing databases, you must"
			eerror "use pg_dump to export your existing databases to a file, and then"
			eerror "pg_restore to import them when you have upgraded completely."
			eerror "You must remove your entire database directory to continue."
			eerror "(database directory = ${PG_DIR})."
			exit 1
		fi
	fi
	enewgroup postgres 70 \
		|| die "problem adding group postgres"
	enewuser postgres 70 /bin/bash /var/lib/postgresql postgres \
		|| die "problem adding user postgres"
}

src_unpack() {
	unpack ${A} || die
	cd ${S}
	use pg-hier && epatch ${WORKDIR}/${P_HIERPG}.diff

	epatch ${FILESDIR}/${PN}-${FILES_VER}-gentoo.patch
	epatch ${FILESDIR}/${PN}-${FILES_VER}-sh.patch
}

src_compile() {
	filter-flags -ffast-math -feliminate-dwarf2-dups

	local myconf
	use tcltk && myconf="--with-tcl"
	use python && myconf="$myconf --with-python"
	use perl && myconf="$myconf --with-perl"
	use ssl && myconf="$myconf --with-openssl"
	use nls && myconf="$myconf --enable-nls"
	use libg++ && myconf="$myconf --with-CXX"
	use pam && myconf="$myconf --with-pam"
	use readline || myconf="$myconf --without-readline"
	use zlib || myconf="$myconf --without-zlib"
	use kerberos && myconf="$myconf --with-krb5"
	use pg-intdatetime && myconf="$myconf --enable-integer-datetimes"

	# these are the only working CFLAGS I could get on ppc, so locking them
	# down, anything more aggressive fails (i.e. -mcpu or -Ox)
	# Gerk - Nov 26, 2002
	use ppc && CFLAGS="-pipe -fsigned-char"

	# Detect mips systems properly
	gnuconfig_update

	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--host=${CHOST} \
		--with-docdir=/usr/share/doc/${PF} \
		--libdir=/usr/$(get_libdir) \
		--enable-depend \
		$myconf || die

	make LD="$(tc-getLD) $(get_abi_LDFLAGS)" || die
	cd contrib
	make LD="$(tc-getLD) $(get_abi_LDFLAGS)" || die
	if use xml2; then
		cd xml2
		make LD="$(tc-getLD) $(get_abi_LDFLAGS)" || die
	fi
}

src_install() {
	if use perl; then
		mv ${S}/src/pl/plperl/Makefile ${S}/src/pl/plperl/Makefile_orig
		sed -e "s:(INST_DYNAMIC) /usr/lib:(INST_DYNAMIC) ${D}/usr/lib:" \
			${S}/src/pl/plperl/Makefile_orig > ${S}/src/pl/plperl/Makefile
		mv ${S}/src/pl/plperl/GNUmakefile ${S}/src/pl/plperl/GNUmakefile_orig
		sed -e "s:\$(DESTDIR)\$(plperl_installdir):\$(plperl_installdir):" \
			${S}/src/pl/plperl/GNUmakefile_orig > ${S}/src/pl/plperl/GNUmakefile
	fi

	make DESTDIR=${D} LIBDIR=${D}/usr/lib install || die
#	make DESTDIR=${D} install-all-headers || die
	cd ${S}/contrib
	make DESTDIR=${D} LIBDIR=${D}/usr/lib install || die
	if use xml2; then
		cd ${S}/contrib/xml2
		make DESTDIR=${D} LIBDIR=${D}/usr/lib install || die
	fi
	cd ${S}
	dodoc README HISTORY COPYRIGHT INSTALL
	dodoc contrib/adddepend/*

	exeinto /usr/bin

	cd ${S}/doc
	dodoc FAQ* README.* TODO bug.template
	if use doc; then
		cd ${S}/doc
		docinto FAQ_html
		dodoc src/FAQ/*
		docinto sgml
		dodoc src/sgml/*.{sgml,dsl}
		docinto sgml/ref
		dodoc src/sgml/ref/*.sgml
		docinto TODO.detail
		dodoc TODO.detail/*
	fi

	cd ${S}
	exeinto /etc/init.d/
	newexe ${FILESDIR}/postgresql.init-${FILES_VER} postgresql || die
	newexe ${FILESDIR}/pg_autovacuum.init-${FILES_VER} pg_autovacuum || die
	dosed "s:___DOCDIR___:/usr/share/doc/${PF}:" /etc/init.d/pg_autovacuum

	insinto /etc/conf.d/
	newins ${FILESDIR}/postgresql.conf-${FILES_VER} postgresql || die
	newins ${FILESDIR}/pg_autovacuum.conf-${FILES_VER} pg_autovacuum || die

	rm ${D}/usr/include/postgres_ext.h
}

pkg_postinst() {
	einfo "Make sure the postgres user in /etc/passwd has an account setup with /bin/bash as the shell"

	if [ ! -f ${PG_DIR}/data/PG_VERSION ] ; then
		einfo ""
		einfo "Execute the following command"
		einfo "emerge --config =${PF}"
		einfo "to setup the initial database environment."
		einfo ""
	fi
}

pkg_config() {
	einfo "Creating the data directory ..."
	mkdir -p ${PG_DIR}/data
	chown -Rf postgres:postgres ${PG_DIR}
	chmod 700 ${PG_DIR}/data

	einfo "Initializing the database ..."
	if [ -f ${PG_DIR}/data/PG_VERSION ] ; then
		eerror "Postgres ${MY_PV} cannot upgrade your existing databases."
		eerror "You must remove your entire database directory to continue."
		eerror "(database directory = ${PG_DIR})."
		exit 1
	else
		local SEM=`sysctl -n kernel.sem | cut -f-3`
		local SEMMNI=`sysctl -n kernel.sem | cut -f4`
		local SEMMNI_MIN=`expr \( ${MAX_CONNECTIONS} + 15 \) / 16`
		local SHMMAX=`sysctl -n kernel.shmmax`
		local SHMMAX_MIN=`expr 250000 + 8200 \* 1000 + 14200 \* 100`

		if [ ${SEMMNI} -lt ${SEMMNI_MIN} ]; then
			eerror "The current value of SEMMNI is too low"
			eerror "for postgresql to run ${MAX_CONNECTIONS} connections"
			eerror "Temporary setting this value to ${SEMMNI_MIN} while creating the initial database."
			echo ${SEM} ${SEMMNI_MIN} > /proc/sys/kernel/sem
		fi
		su postgres -c "/usr/bin/initdb --pgdata ${PG_DIR}/data"

		if [ ! `sysctl -n kernel.sem | cut -f4` -eq ${SEMMNI} ] ; then
			echo ${SEM} ${SEMMNI} > /proc/sys/kernel/sem
			ewarn "Restoring the SEMMNI value to the previous value"
			ewarn "Please edit the last value of kernel.sem in /etc/sysctl.conf"
			ewarn "and set it to at least ${SEMMNI_MIN}"
			ewarn ""
			ewarn "  kernel.sem = ${SEM} ${SEMMNI_MIN}"
			ewarn ""
		fi

		if [ ${SHMMAX} -lt ${SHMMAX_MIN} ]; then
			eerror "The current value of SHMMAX is too low for postgresql to run."
			eerror "Please edit /etc/sysctl.conf and set this value to at least ${SHMMAX_MIN}."
			eerror ""
			eerror "  kernel.shmmax = ${SHMMAX_MIN}"
			eerror ""

		fi
		einfo ""
		einfo "You can use /etc/init.d/postgresql script to run PostgreSQL instead of pg_ctl."
		einfo ""
	fi
}
