# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/mod_php/mod_php-4.2.3-r2.ebuild,v 1.1 2002/12/13 15:30:33 woodchip Exp $

IUSE="apache2 freetype postgres tiff libwww nls jpeg ssl gd oci8 mysql X gdbm curl imap png xml2 xml cjk pdflib qt snmp crypt flash odbc ldap berkdb freetds firebird pam"

MY_P=php-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Apache module for PHP"
SRC_URI="http://us3.php.net/distributions/${MY_P}.tar.bz2"
HOMEPAGE="http://www.php.net/"
LICENSE="PHP"
KEYWORDS="~x86 ~ppc ~sparc"
SLOT="0"
PROVIDE="virtual/php"

	# users have been having problems with compiling the gmp support... disabled for now
	# - rphillips
	#>=dev-libs/gmp-3.1.1

DEPEND="
	>=net-www/apache-1.3.26-r2
	apache2? ( >=net-www/apache-2.0.43 )
	freetype? ( ~media-libs/freetype-1.3.1 >=media-libs/t1lib-1.3.1 )
	jpeg? ( >=media-libs/jpeg-6b )
	tiff? ( >=media-libs/tiff-3.5.5 )
	png? ( >=media-libs/libpng-1.2.1 )
	gd? ( >=media-libs/libgd-1.8.3 )
	X? ( virtual/x11 )
	qt? ( x11-libs/qt )
	nls? ( sys-devel/gettext )
	pam? ( >=sys-libs/pam-0.75 )
	xml? ( >=net-libs/libwww-5.3.2 >=app-text/sablotron-0.95-r1 )
	ssl? ( >=dev-libs/openssl-0.9.5 )
	curl? ( >=net-ftp/curl-7.8.1 )
	snmp? ( >=net-analyzer/ucd-snmp-4.2.3 )
	imap? ( >=net-mail/uw-imap-2001a-r1 )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	ldap? ( >=net-nds/openldap-1.2.11 )
	odbc? ( >=dev-db/unixODBC-1.8.13 )
	xml2? ( dev-libs/libxml2 )
	crypt? ( >=dev-libs/libmcrypt-2.4
	>=app-crypt/mhash-0.8 )
	mysql? ( >=dev-db/mysql-3.23.26 )
	freetds? ( >=dev-db/freetds-0.53 )
	flash? ( media-libs/libswf >=media-libs/ming-0.2a )
	berkdb? ( >=sys-libs/db-3 )
	libwww? ( >=net-libs/libwww-5.3.2 )
	firebird? ( >=dev-db/firebird-1.0 )
	pdflib? ( >=media-libs/pdflib-4.0.1-r2 )
	postgres? ( >=dev-db/postgresql-7.1 )"
	#java? ( virtual/jdk )
# Only needed by CGI-Version
#	readline? ( >=sys-libs/ncurses-5.1
#		>=sys-libs/readline-4.1 )"

RDEPEND="
	xml? ( >=app-text/sablotron-0.95-r1 )
	qt? ( >=x11-libs/qt-2.3.0 )"

src_unpack() {
	unpack ${MY_P}.tar.bz2
	cd ${S}

        # Configure Patch for wired uname -a
	mv configure configure.old
	cat configure.old | sed "s/PHP_UNAME=\`uname -a\`/PHP_UNAME=\`uname -s -n -r -v\`/g" > configure
	chmod 755 configure

	#if [ "`use java`" ] ; then

	#	cp configure configure.orig
	#	cat configure.orig | \
	#		sed -e 's/LIBS="-lttf $LIBS"/LIBS="-lttf $LIBS"/' \
	#		> configure

	#	cp ext/gd/gd.c ext/gd/gd.c.orig
	#	cat ext/gd/gd.c.orig | \
	#		sed -e "s/typedef FILE gdIOCtx;//" \
	#		> ext/gd/gd.c
	#	if [ "$JAVAC" ];
	#	then
	#              cp ext/java/Makefile.in ext/java/Makefile.in.orig
	#              cat ext/java/Makefile.in.orig | \
	#                      sed -e "s/^\tjavac/\t\$(JAVAC)/" \
	#                      > ext/java/Makefile.in
	#	fi
	#fi

}

src_compile() {

	local myconf

	# readline can only be used w/ CGI build, so I'll turn it off
	#if [ "`use readline`" ] ; then
	#  myconf="--with-readline"
	#fi

	myconf="--without-readline "
	use pam && myconf="${myconf} --with-pam"
	use nls && myconf="${myconf} --with-gettext" || myconf="${myconf} --without-gettext"
	use ssl && myconf="${myconf} --with-openssl"
	use curl && myconf="${myconf} --with-curl"
	use snmp && myconf="${myconf} --with-snmp --enable-ucd-snmp-hack"
	use cjk && myconf="${myconf} --enable-mbstring"
	use gdbm && myconf="${myconf} --with-gdbm=/usr"
	use berkdb && myconf="${myconf} --with-db3=/usr"
	use mysql && myconf="${myconf} --with-mysql=/usr" || myconf="${myconf} --without-mysql"
	use freetds && myconf="${myconf} --with-sybase=/usr"
	use postgres && myconf="${myconf} --with-pgsql=/usr"
	use odbc && myconf="${myconf} --with-unixODBC=/usr"
	use ldap &&  myconf="${myconf} --with-ldap"
	use firebird && myconf="${myconf} --with-interbase=/opt/interbase"
	use freetype && myconf="${myconf} --with-ttf --with-t1lib"
	use pdflib && myconf="${myconf} --with-pdflib=/usr"
	use gd && myconf="${myconf} --with-gd"
	use png && myconf="${myconf} --with-png-dir=/usr"	
	use jpeg && myconf="${myconf} --with-jpeg-dir=/usr/lib"
	use tiff && myconf="${myconf} --with-tiff-dir=/usr"

	# optional support for apache2
	myconf="${myconf} --with-exec-dir=/usr/bin"
	if [ "`use apache2`" ] ; then
		myconf="${myconf} --with-apxs2=/usr/sbin/apxs2"
	else
		myconf="${myconf} --with-apxs=/usr/sbin/apxs"
	fi

	# optional support for oracle oci8
	if [ "`use oci8`" ] ; then
		if [ "$ORACLE_HOME" ] ; then
			myconf="${myconf} --with-oci8=${ORACLE_HOME}"
		fi
	fi

	use qt && ( \
		export QTDIR=/usr/qt/2 #hope this helps - danarmak
		myconf="${myconf} --with-qtdom" 
	)

	if [ "`use imap`" ] ; then
		if [ "`use ssl`" ] && [ "`strings ${ROOT}/usr/lib/c-client.a \
					| grep ssl_onceonlyinit`" ] ; then
			echo "Compiling imap with SSL support"
			myconf="${myconf} --with-imap --with-imap-ssl"
		else
			echo "Compiling imap without SSL support"
			myconf="${myconf} --with-imap"
		fi
	fi
	use libwww && myconf="${myconf} --with-xml" || myconf="${myconf} --disable-xml"
	use flash && myconf="${myconf} --with-swf=/usr --with-ming=/usr"

	if [ "`use xml`" ] ; then
		export LIBS="-lxmlparse -lxmltok"
		myconf="${myconf} --with-sablot=/usr"
		myconf="${myconf} --enable-xslt" 
		myconf="${myconf} --with-xslt-sablot" 
		myconf="${myconf} --with-xmlrpc"
	fi

	use xml2 && myconf="${myconf} --with-dom"
	use crypt && myconf="${myconf} --with-mcrypt --with-mhash --disable-posix-threads"
	#use java && myconf="${myconf} --with-java=${JDK_HOME}"

	LDFLAGS="$LDFLAGS -ltiff -ljpeg"

	if [ "`use X`" ] ; then
		myconf="${myconf} --with-xpm-dir=/usr/X11R6"
		LDFLAGS="$LDFLAGS -L/usr/X11R6/lib"
	fi

	# this needed moving to prevent b0rkage
	# Please test your ebuilds!
	# --with-gmp \

	./configure \
		--prefix=/usr \
		--with-bz2 \
		--enable-ftp \
		--enable-wddx \
		--enable-dbase \
		--with-zlib=yes \
		--enable-bcmath \
		--enable-sysvsem \
		--enable-sysvshm \
		--enable-sockets \
		--enable-calendar \
		--enable-trans-sid \
		--enable-safe-mode \
		--enable-versioning \
		--enable-track-vars \
		--enable-inline-optimization \
		--with-config-file-path=/etc/php4 \
		--host=${CHOST} ${myconf} || die "bad ./configure"

	make || die "compile problem"
}


src_install() {
 	make INSTALL_ROOT=${D} install-pear || die

	dodoc CODING_STANDARDS LICENSE EXTENSIONS 
	dodoc RELEASE_PROCESS README.* TODO NEWS
	dodoc ChangeLog* *.txt

	cat php.ini-dist | sed "s/register_globals = Off/register_globals = On/g" > php.ini
	insinto /etc/php4
	doins php.ini
	dosym /usr/lib/php/extensions/no-debug-non-zts-20020429 /etc/php4/lib

	if [ "`use apache2`" ] ; then
		exeinto /usr/lib/apache2-extramodules
		doexe .libs/libphp4.so
		insinto /etc/apache2/conf/modules.d
		doins ${FILESDIR}/70_mod_php.conf
		dosym /etc/php4/php.ini /etc/apache2/conf/php.ini
	else
		exeinto /usr/lib/apache-extramodules
		doexe .libs/libphp4.so
		insinto /etc/apache/conf/addon-modules
		doins ${FILESDIR}/mod_php.conf
		dosym /etc/php4/php.ini /etc/apache/conf/php.ini
		dosym /etc/php4/php.ini /etc/apache/conf/addon-modules/php.ini
	fi
}

pkg_postinst() {
	einfo
	einfo "To have Apache run php programs, please do the following:"
	if [ "`use apache2`" ] ; then
		einfo "Edit /etc/conf.d/apache2 and add \"-D PHP4\""
		einfo
		einfo "Please note Apache 2 support in php is currently experimental"
	else
		einfo "1. Execute the command:"
		einfo " \"ebuild /var/db/pkg/dev-php/${PF}/${PF}.ebuild config\""
		einfo "2. Edit /etc/conf.d/apache and add \"-D PHP4\""
		einfo
		einfo "That will include the php mime types in your configuration"
		einfo "automagically and setup Apache to load php when it starts."
	fi
	einfo
	einfo "Please remeber:"
	einfo "This install of PHP has set register_globals = On (lower security)"
	einfo "Please read http://www.php.net/release_4_1_2.php"
	einfo "(Section: External variables) for further information."
	einfo
}

pkg_config() {
	${ROOT}/usr/sbin/apacheaddmod \
		${ROOT}/etc/apache/conf/apache.conf \
		extramodules/libphp4.so mod_php4.c php4_module \
		before=perl define=PHP4 addconf=conf/addon-modules/mod_php.conf
	:;
}
