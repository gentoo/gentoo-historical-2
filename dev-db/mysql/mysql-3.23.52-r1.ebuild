# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql/mysql-3.23.52-r1.ebuild,v 1.1 2002/09/29 22:34:20 rphillips Exp $

SVER=${PV%.*}
#normal releases:
SDIR=MySQL-${SVER}
#for a pre-release:
#SDIR=MySQL-${SVER}-Pre

DESCRIPTION="A fast, multi-threaded, multi-user SQL database server."
HOMEPAGE="http://www.mysql.com/"
SRC_URI="ftp://ftp.sunet.se/pub/unix/databases/relational/mysql/Downloads/${SDIR}/${P}.tar.gz
	ftp://mysql.valueclick.com/pub/mysql/Downloads/${SDIR}/${P}.tar.gz"
S=${WORKDIR}/${P}
LICENSE="GPL-2"
SLOT="0"

DEPEND="readline? ( >=sys-libs/readline-4.1 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	>=sys-libs/zlib-1.1.3
	sys-devel/perl
	sys-apps/procps"

RDEPEND="${DEPEND}"
KEYWORDS="x86"

# HEY!
# the benchmark stuff in /usr/share/mysql/sql-bench and
# the /usr/bin/mysql_setpermission script need dev-perl/DBD-mysql.
# Can't add it here: circ depend.  Emerge it either before or after
# mysql; easier before, then it pulls in mysql.

src_unpack() {
	unpack ${A} || die
	cd ${S} || die
	# required for qmail-mysql
	patch -p0 < ${FILESDIR}/mysql-3.23-nisam.h.diff || die
	# zap startup script messages
	patch -p1 < ${FILESDIR}/${P}-install-db-sh.diff || die
	# zap binary distribution stuff
	patch -p1 < ${FILESDIR}/mysql-3.23-safe-mysqld-sh.diff || die
	# for correct hardcoded sysconf directory
	patch -p1 < ${FILESDIR}/mysql-3.23-my-print-defaults.diff || die
	#patch -p1 < ${FILESDIR}/mysql-3.23.51-tcpd.patch || die
}

src_compile() {
	local myconf
	myconf="--with-thread-safe-client"
	use berkdb && myconf="${myconf} --with-berkeley-db=./bdb"
	use berkdb || myconf="${myconf} --without-berkeley-db"
	use readline && myconf="${myconf} --with-readline"
	use readline || myconf="${myconf} --without-readline"
	use static && myconf="${myconf} --with-mysqld-ldflags=-all-static --disable-shared"
	use static || myconf="${myconf} --enable-shared --enable-static"
	use tcpd && myconf="${myconf} --with-libwrap"
	use tcpd || myconf="${myconf} --without-libwrap"
	use innodb && myconf="${myconf} --with-innodb"
	use innodb || myconf="${myconf} --without-innodb"
	[ -n "${DEBUGBUILD}" ] && myconf="${myconf} --with-debug"
	[ -n "${DEBUGBUILD}" ] || myconf="${myconf} --without-debug"

	# the compiler flags are as per their "official" spec ;-)
	einfo "myconf is $myconf"
	CFLAGS="${CFLAGS/-O?/} -O3" \
	CXXFLAGS="${CXXFLAGS/-O?/} -O3 -felide-constructors -fno-exceptions -fno-rtti" \
	econf \
		--sysconfdir=/etc/mysql \
		--localstatedir=/var/lib/mysql \
		--with-raid \
		--with-low-memory \
		--enable-assembler \
		--with-charset=latin1 \
		--with-mysqld-user=mysql \
		--with-extra-charsets=all \
		--enable-thread-safe-client \
		--with-client-ldflags=-lstdc++ \
		--with-comment="Gentoo ${PF}.ebuild package" \
		--with-unix-socket-path=/var/run/mysqld/mysqld.sock \
		${myconf} || die "bad ./configure"

	make || die "compile problem"
}

src_install() {
	make install DESTDIR=${D} benchdir_root=/usr/share/mysql || die

	# eeek, not sure whats going on here.. are these needed by anything?
	use innodb && insinto /usr/lib/mysql && doins ${WORKDIR}/../libs/*

	# move client libs, install a couple of missing headers
	mv ${D}/usr/lib/mysql/libmysqlclient*.so* ${D}/usr/lib
	dosym ../libmysqlclient.so /usr/lib/mysql/libmysqlclient.so
	dosym ../libmysqlclient_r.so /usr/lib/mysql/libmysqlclient_r.so
	insinto /usr/include/mysql ; doins include/{my_config.h,my_dir.h}

	# convenience links
	dosym /usr/bin/mysqlcheck /usr/bin/mysqlanalyze
	dosym /usr/bin/mysqlcheck /usr/bin/mysqlrepair
	dosym /usr/bin/mysqlcheck /usr/bin/mysqloptimize

	# while my broom gently sweeps...
	rm -f ${D}/usr/share/mysql/binary-configure
	rm -f ${D}/usr/share/mysql/mysql.server
	rm -f ${D}/usr/share/mysql/make_binary_distribution
	rm -f ${D}/usr/share/mysql/mi_test_all*
	rm -f ${D}/usr/share/mysql/mysql-log-rotate
	rm -f ${D}/usr/share/mysql/mysql*.spec
	rm -f ${D}/usr/share/mysql/my-*.cnf

	dodoc README COPYING COPYING.LIB MIRRORS \
		Docs/{manual.ps,manual.txt}
	docinto conf-samples
	dodoc support-files/my-*.cnf
	dohtml -r Docs/*

	insinto /etc/mysql
	doins ${FILESDIR}/my.cnf scripts/mysqlaccess.conf
	exeinto /etc/init.d
	newexe ${FILESDIR}/mysql.init mysql
}

pkg_config() {
	if [ ! -d ${ROOT}/var/lib/mysql/mysql ] ; then
		einfo "Press ENTER to create the mysql database and set proper"
		einfo "permissions on it, or Control-C to abort now..."
		read
		${ROOT}/usr/bin/mysql_install_db #>>/var/log/mysql/mysql.err 2>&1
	else
		einfo "Hmm, it appears as though you already have the mysql"
		einfo "database in place.  If you are having problems trying"
		einfo "to start mysqld, perhaps you need to manually run"
		einfo "/usr/bin/mysql_install_db and/or check your config"
		einfo "file(s) and/or database(s) and/or logfile(s)."
	fi
}

pkg_preinst() {
	if ! groupmod mysql; then
		groupadd -g 60 mysql || die "problem adding group mysql"
	fi

	if ! id mysql; then
		useradd -g mysql -s /dev/null -d /var/lib/mysql -c "mysql" mysql
		assert "problem adding user mysql"
	fi
}

pkg_postinst() {
	# empty dirs...
	install -d -m0755 -o mysql -g mysql ${ROOT}/var/lib/mysql
	install -d -m0755 -o mysql -g mysql ${ROOT}/var/run/mysqld
	install -d -m0755 -o mysql -g mysql ${ROOT}/var/log/mysql

	# secure the logfiles... does this bother anybody?
	touch ${ROOT}/var/log/mysql/mysql.{log,err}
	chown mysql.mysql ${ROOT}/var/log/mysql/mysql.{log,err}
	chmod 0660 ${ROOT}/var/log/mysql/mysql.{log,err}

	# your friendly public service announcement...
	einfo
	einfo "You might want to run:"
	einfo "\"ebuild /var/db/pkg/dev-db/${PF}/${PF}.ebuild config\""
	einfo "if this is a new install."
	einfo
}
