# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/mod_php/mod_php-4.3.10.ebuild,v 1.7 2005/01/09 20:58:25 weeve Exp $

IUSE="${IUSE} apache2"

KEYWORDS="x86 ppc sparc alpha ~hppa amd64 ~ia64 ~s390 ppc64 ~mips"

detectapache() {
	local domsg=
	[ -n "$1" ] && domsg=1
	HAVE_APACHE1=
	HAVE_APACHE2=
	has_version '=net-www/apache-1*' && HAVE_APACHE1=1
	has_version '=net-www/apache-2*' && HAVE_APACHE2=1

	[ -n "${HAVE_APACHE1}" ] && APACHEVER=1
	[ -n "${HAVE_APACHE2}" ] && APACHEVER=2
	[ -n "${HAVE_APACHE1}" ] && [ -n "${HAVE_APACHE2}" ] && APACHEVER='both'

	case "${APACHEVER}" in
	1) [ -n "${domsg}" ] && einfo 'Apache1 only detected' ;;
	2) [ -n "${domsg}" ] && einfo 'Apache2 only detected';;
	both)
		if use apache2; then
			[ -n "${domsg}" ] && einfo "Multiple Apache versions detected, using Apache2 (USE=apache2)"
			APACHEVER=2
		else
			[ -n "${domsg}" ] && einfo 'Multiple Apache versions detected, using Apache1 (USE=-apache2)'
			APACHEVER=1
		fi ;;
	*) if [ -n "${domsg}" ]; then
			MSG="Unknown Apache version!"; eerror $MSG ; die $MSG
	   else
			APACHEVER=0
	   fi; ;;
	esac
}

detectapache

SLOT="${APACHEVER}"
[ "${APACHEVER}" -eq '2' ] && USE_APACHE2='2' || USE_APACHE2=''

PHPSAPI="apache${APACHEVER}"
SRC_URI_BASE="http://downloads.php.net/ilia/" # for RC only

# BIG FAT WARNING!
# the php eclass requires the PHPSAPI setting!
# In this case the PHPSAPI setting is dependant on the detectapache function
# above this point as well!
inherit php-sapi eutils

DESCRIPTION="Apache module for PHP"

DEPEND_EXTRA=">=net-www/apache-1.3.26-r2
			  apache2? ( >=net-www/apache-2.0.43-r1 )"
DEPEND="${DEPEND} ${DEPEND_EXTRA}"
RDEPEND="${RDEPEND} ${DEPEND_EXTRA}"
IUSE="${IUSE} debug"
# for this revision only
PDEPEND=">=${PHP_PROVIDER_PKG}-4.3.10"
PROVIDE="${PROVIDE} virtual/httpd-php-${PV}"

# Add a 'return 0' as we DON'T want the return code checked
pkg_setup() {
	use debug && einfo "Installing in SLOT=${SLOT}"
	return 0
}

src_unpack() {
	multiinstwarn
	detectapache domsg
	php-sapi_src_unpack
	if [ "${ARCH}" == "amd64" ] ; then
		epatch ${FILESDIR}/mod_php-4.3.4-amd64hack.diff
	fi
	[ "${ARCH}" == "sparc" ] && epatch ${FILESDIR}/stdint.diff

	# bug fix for security problem - bug #39952
	# second revision as the apache2 stuff was resolved upstream
	epatch ${FILESDIR}/mod_php-4.3.5-apache1security.diff

	# stop php from activing the apache config, as we will do that ourselves
	for i in configure sapi/apache/config.m4 sapi/apache2filter/config.m4 sapi/apache2handler/config.m4; do
		sed -i.orig -e 's,-i -a -n php4,-i -n php4,g' $i
	done
}

src_compile() {
	# Every Apache2 MPM EXCEPT prefork needs Zend Thread Safety
	if [ -n "${USE_APACHE2}" ]; then
		APACHE2_MPM="`/usr/sbin/apache2 -l |egrep 'worker|perchild|leader|threadpool|prefork'|cut -d. -f1|sed -e 's/^[[:space:]]*//g;s/[[:space:]]+/ /g;'`"
		einfo "Apache2 MPM: ${APACHE2_MPM}"
		case "${APACHE2_MPM}" in
			*prefork*) ;;
			*) myconf="${myconf} --enable-experimental-zts" ; ewarn "Enabling ZTS for Apache2 MPM" ;;
		esac;
	fi

	#use apache2 \
	myconf="${myconf} --with-apxs${USE_APACHE2}=/usr/sbin/apxs${USE_APACHE2}"

	php-sapi_src_compile
}


src_install() {
	PHP_INSTALLTARGETS="install"
	php-sapi_src_install
	einfo "Adding extra symlink to php.ini for Apache${USE_APACHE2}"
	dodir /etc/apache${USE_APACHE2}/conf/
	dodir ${PHPINIDIRECTORY}
	dosym ${PHPINIDIRECTORY}/${PHPINIFILENAME} /etc/apache${USE_APACHE2}/conf/${PHPINIFILENAME}

	einfo "Cleaning up a little"
	rm -rf ${D}/usr/lib/apache${USE_APACHE2}/modules/libphp4.so
	einfo "Adding extra symlink to Apache${USE_APACHE2} extramodules for PHP"
	dosym /usr/lib/apache${USE_APACHE2}-extramodules ${PHPINIDIRECTORY}/lib
	exeinto /usr/lib/apache${USE_APACHE2}-extramodules
	einfo "Installing mod_php shared object now"
	doexe .libs/libphp4.so

	if [ -n "${USE_APACHE2}" ] ; then
		einfo "Installing a Apache2 config for PHP (70_mod_php.conf)"
		insinto /etc/apache2/conf/modules.d
		doins ${FILESDIR}/70_mod_php.conf
	else
		einfo "Installing a Apache config for PHP (mod_php.conf)"
		insinto /etc/apache/conf/addon-modules
		doins ${FILESDIR}/mod_php.conf
		dosym ${PHPINIDIRECTORY}/${PHPINIFILENAME} /etc/apache/conf/addon-modules/${PHPINIFILENAME}
	fi
}

apache2msg() {
	einfo "Edit /etc/conf.d/apache2 and add \"-D PHP4\" to APACHE2_OPTS"
	ewarn "This is a CHANGE from previous behavior, which was \"-D PHP\""
	ewarn "This is for the upcoming PHP5 support. The ebuild will attempt"
	ewarn "to make this update between PHP and PHP4 automatically"
}

multiinstwarn() {
	ewarn "Due to some previous bloopers with PHP and slotting, you may have"
	ewarn "multiple instances of mod_php installed. Please look at the autoclean"
	ewarn "output at the end of the emerge and unmerge all but relevant"
	ewarn "instances."
}

apache2fix() {
	if egrep -q -- '-D PHP\>' /etc/conf.d/apache2; then
		einfo "Attemping to update /etc/conf.d/apache2 automatically for the PHP/PHP4 change."
		local oldfile="/etc/conf.d/apache2.old.`date +%Y%m%d%H%M%S`"
		cp /etc/conf.d/apache2 ${oldfile}
		sed -re 's,-D PHP\>,-D PHP4,g' ${oldfile}  <${oldfile} >/etc/conf.d/apache2
	fi
}


pkg_preinst() {
	multiinstwarn
	[ "${APACHEVER}" -eq '2' ] && apache2fix
	php-sapi_pkg_preinst
}

pkg_postinst() {
	php-sapi_pkg_postinst
	multiinstwarn
	einfo "To have Apache run php programs, please do the following:"
	if [ -n "${USE_APACHE2}" ]; then
		apache2msg
	else
		einfo "1. Execute the command:"
		einfo " \"ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config\""
		einfo "2. Edit /etc/conf.d/apache and add \"-D PHP4\" to APACHE_OPTS"
		einfo "That will include the php mime types in your configuration"
		einfo "automagically and setup Apache to load php when it starts."
	fi
}

pkg_config() {
	multiinstwarn
	if [ -n "${USE_APACHE2}" ]; then
		apache2msg
	else
		${ROOT}/usr/sbin/apacheaddmod \
			${ROOT}/etc/apache/conf/apache.conf \
			extramodules/libphp4.so mod_php4.c php4_module \
			before=perl define=PHP4 addconf=conf/addon-modules/mod_php.conf
			:;
	fi
}
