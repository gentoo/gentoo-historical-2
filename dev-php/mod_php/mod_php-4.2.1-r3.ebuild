# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Tools Team <tools@gentoo.org>
# Author: Achim Gottinger <achim@gentoo.org>
# Update: Roman Weber <gentoo@gonzo.ch>
# $Header: /var/cvsroot/gentoo-x86/dev-php/mod_php/mod_php-4.2.1-r3.ebuild,v 1.1 2002/07/03 21:02:54 owen Exp $

A=php-${PV}.tar.gz
S=${WORKDIR}/php-${PV}
DESCRIPTION="HTML embedded scripting language"
SRC_URI="http://www.php.net/distributions/${A}"
HOMEPAGE="http://www.php.net/"
LICENSE="PHP"
SLOT="0"

DEPEND=">=dev-libs/gmp-3.1.1
	>=net-www/apache-1.3.24-r1
	freetype? ( ~media-libs/freetype-1.3.1 >=media-libs/t1lib-1.3.1 )
	jpeg? ( >=media-libs/jpeg-6b )
	tiff? ( >=media-libs/tiff-3.5.5 )
	png? ( >=media-libs/libpng-1.2.1 )
	gd? ( >=media-libs/libgd-1.8.3 )
	X? ( virtual/x11 )
	qt? ( =x11-libs/qt-2.3* )
	nls? ( sys-devel/gettext )
	pam? ( >=sys-libs/pam-0.75 )
	xml? ( >=app-text/sablotron-0.44 )
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
	flash? ( media-libs/libswf >=media-libs/ming-0.2a )
	berkdb? ( >=sys-libs/db-3 )
	libwww? ( >=net-libs/libwww-5.3.2 )
	firebird? ( >=dev-db/firebird-1.0 )
	pdflib? ( >=media-libs/pdflib-4.0.1-r2 )
	postgres? ( >=dev-db/postgresql-7.1 )"
#	java? ( virtual/jdk )
# Only needed by CGI-Version
#	readline? ( >=sys-libs/ncurses-5.1
#		>=sys-libs/readline-4.1 )"

RDEPEND="${DEPEND}
	qt? ( >=x11-libs/qt-2.3.0 )
	xml? ( >=app-text/sablotron-0.44 )"

src_unpack() {
	unpack ${A}
	cd ${S}

#	if [ "`use java`" ] ; then
#
#		cp configure configure.orig
#		cat configure.orig | \
#			sed -e 's/LIBS="-lttf $LIBS"/LIBS="-lttf $LIBS"/' \
#			> configure
#
#		cp ext/gd/gd.c ext/gd/gd.c.orig
#		cat ext/gd/gd.c.orig | \
#			sed -e "s/typedef FILE gdIOCtx;//" \
#			> ext/gd/gd.c
#		if [ "$JAVAC" ];
#		then
#	              cp ext/java/Makefile.in ext/java/Makefile.in.orig
#	              cat ext/java/Makefile.in.orig | \
#	                      sed -e "s/^\tjavac/\t\$(JAVAC)/" \
#	                      > ext/java/Makefile.in
#		fi
#	fi

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
	use gdbm && myconf="${myconf} --with-gdbm=/usr"
	use berkdb && myconf="${myconf} --with-db3=/usr"
	use mysql && myconf="${myconf} --with-mysql=/usr" || myconf="${myconf} --without-mysql"
	use postgres && myconf="${myconf} --with-pgsql=/usr"
	use odbc && myconf="${myconf} --with-unixODBC=/usr"
	use ldap &&  myconf="${myconf} --with-ldap" 
	use pdflib && myconf="${myconf} --with-pdflib=/usr"
	use firebird && myconf="${myconf} --with-interbase=/opt/interbase"
	use gd && myconf="${myconf} --with-gd"
	use freetype && myconf="${myconf} --with-ttf --with-t1lib"
	use jpeg && myconf="${myconf} --with-jpeg-dir=/usr/lib"
	use png && myconf="${myconf} --with-png-dir=/usr"	
	use tiff && myconf="${myconf} --with-tiff-dir=/usr"

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
	fi

	use xml2 && myconf="${myconf} --with-dom"
	use crypt && myconf="${myconf} --with-mcrypt --with-mhash"
#	use java && myconf="${myconf} --with-java=${JDK_HOME}"

	LDFLAGS="$LDFLAGS -ltiff -ljpeg"

	if [ "`use X`" ] ; then
		myconf="${myconf} --with-xpm-dir=/usr/X11R6"
		LDFLAGS="$LDFLAGS -L/usr/X11R6/lib"
	fi
    
	./configure \
		--prefix=/usr \
		--with-gmp \
                --with-bz2 \
		--enable-ftp \
		--enable-dbase \
		--with-zlib=yes \
		--enable-bcmath \
		--enable-sysvsem \
		--enable-sysvshm \
		--enable-calendar \
		--enable-trans-sid \
		--enable-safe-mode \
		--enable-versioning \
		--enable-track-vars \
		--enable-inline-optimization \
		--with-apxs="/usr/sbin/apxs -ltiff" \
		--with-exec-dir="/usr/lib/apache/bin" \
		--with-config-file-path=/etc/php4 \
		--host=${CHOST} ${myconf} || die "bad ./configure"

	make || die "compile problem"
}


src_install() {
 	make INSTALL_ROOT=${D} install-pear || die

	dodoc CODING_STANDARDS LICENSE EXTENSIONS 
	dodoc RELEASE_PROCESS README.* TODO NEWS
	dodoc ChangeLog* *.txt

	exeinto /usr/lib/apache-extramodules
	doexe .libs/libphp4.so

	insinto /etc/apache/conf/addon-modules
	doins ${FILESDIR}/mod_php.conf
	insinto /etc/php4
	cat php.ini-dist | sed "s/register_globals = Off/register_globals = On/g" > php.ini
	doins php.ini
	dosym /etc/php4/php.ini /etc/apache/conf/php.ini
	dosym /etc/php4/php.ini /etc/apache/conf/addon-modules/php.ini
	dosym /usr/lib/php/extensions/no-debug-non-zts-20020429 /etc/php4/lib
}

pkg_postinst() {
	einfo
	einfo "Execute ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	einfo "to have your apache.conf auto-updated for use with this module."
	einfo "You should then edit your /etc/conf.d/apache file to suit."
	einfo
	einfo "Please remeber:"
	einfo "This install of PHP has set register_globals = On (lower security)"
	einfo "Please read http://www.php.net/release_4_1_2.php (Section: External variables)"
	einfo "for further informations."
	einfo
}

pkg_config() {
	${ROOT}/usr/sbin/apacheaddmod \
		${ROOT}/etc/apache/conf/apache.conf \
		extramodules/libphp4.so mod_php4.c php4_module \
		before=perl define=PHP4 addconf=conf/addon-modules/mod_php.conf
	:;
}

