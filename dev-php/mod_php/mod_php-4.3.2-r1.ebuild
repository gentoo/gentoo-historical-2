# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/mod_php/mod_php-4.3.2-r1.ebuild,v 1.6 2003/10/26 03:33:13 robbat2 Exp $

use apache2 && PHPSAPI="apache2" || PHPSAPI="apache1"
inherit php eutils

IUSE="${IUSE} apache2"

DESCRIPTION="Apache module for PHP"
KEYWORDS="~x86 ~sparc ~ppc ~alpha ~hppa ~arm"
EXCLUDE_DB4_FIX=1
EXCLUDE_PEAR_FIX=1

DEPEND="${DEPEND}
	>=net-www/apache-1.3.26-r2
	apache2? ( >=net-www/apache-2.0.43-r1 ) "

APACHEVER='1'
use apache2 && APACHEVER='2'
SLOT="${APACHEVER}"
[ "${APACHEVER}" -eq '2' ] && USE_APACHE2='2' || USE_APACHE2=''

src_compile() {
	#no readline on server SAPI
	myconf="${myconf} --without-readline"

	# Every Apache2 MPM EXCEPT prefork needs Zend Thread Safety
	if [ -n "${USE_APACHE2}" ]; then
		APACHE2_MPM="`apache2 -l |egrep 'worker|perchild|leader|threadpool|prefork'|cut -d. -f1|sed -e 's/^[[:space:]]*//g;s/[[:space:]]+/ /g;'`"
		case "${APACHE2_MPM}" in
			*prefork*) ;;
			*) myconf="${myconf} --enable-experimental-zts" ;;
		esac;
	fi

	# optional support for apache2
	#&& myconf="${myconf} --with-apxs2=/usr/sbin/apxs2" \
	#|| myconf="${myconf} --with-apxs=/usr/sbin/apxs"

	#use apache2 \
	myconf="${myconf} --with-apxs${USE_APACHE2}=/usr/sbin/apxs${USE_APACHE2}"

	#php CGI stuff
	#--enable-discard-path --enable-force-cgi-redirect

	php_src_compile
}


src_install() {
	php_src_install

	cp php.ini-dist php.ini
	insinto /etc/php4
	doins php.ini
	dosym /etc/php4/php.ini /etc/apache${USE_APACHE2}/conf/php.ini

	dosym /usr/lib/apache${USE_APACHE2}-extramodules /etc/php4/lib
	exeinto /usr/lib/apache${USE_APACHE2}-extramodules
	doexe .libs/libphp4.so

	if [ -n "${USE_APACHE2}" ] ; then
		insinto /etc/apache2/conf/modules.d
		doins ${FILESDIR}/70_mod_php.conf
	else
		insinto /etc/apache/conf/addon-modules
		doins ${FILESDIR}/mod_php.conf
		dosym /etc/php4/php.ini /etc/apache/conf/addon-modules/php.ini
	fi
}

apache2msg() {
		einfo "Edit /etc/conf.d/apache2 and add \"-D PHP\""
}

pkg_postinst() {
	einfo "To have Apache run php programs, please do the following:"
	if [ "`use apache2`" ] ; then
		apache2msg
	else
		einfo "1. Execute the command:"
		einfo " \"ebuild /var/db/pkg/dev-php/${PF}/${PF}.ebuild config\""
		einfo "2. Edit /etc/conf.d/apache and add \"-D PHP\""
		einfo "That will include the php mime types in your configuration"
		einfo "automagically and setup Apache to load php when it starts."
	fi
}

pkg_config() {
	if [ -n "${USE_APACHE2}" ] ; then
		apache2msg
	else
		${ROOT}/usr/sbin/apacheaddmod \
			${ROOT}/etc/apache/conf/apache.conf \
			extramodules/libphp4.so mod_php4.c php4_module \
			before=perl define=PHP4 addconf=conf/addon-modules/mod_php.conf
			:;
	fi
}
