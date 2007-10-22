# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/php-pear-r1.eclass,v 1.18 2007/10/22 22:55:04 jokey Exp $
#
# Author: Tal Peer <coredumb@gentoo.org>
# Author: Luca Longinotti <chtekk@gentoo.org>

# @ECLASS: php-pear-r1.eclass
# @MAINTAINER:
# Gentoo PHP Team <php-bugs@gentoo.org>
# @BLURB: Provides means for an easy installation of PEAR packages.
# @DESCRIPTION:
# This eclass provides means for an easy installation of PEAR packages.
# For more information on PEAR, see http://pear.php.net/
# Note that this eclass doesn't handle dependencies of PEAR packages
# on purpose; please use (R)DEPEND to define them correctly!

EXPORT_FUNCTIONS src_install

DEPEND="dev-lang/php >=dev-php/PEAR-PEAR-1.4.8"
RDEPEND="${DEPEND}"

# @ECLASS-VARIABLE: PHP_PEAR_PKG_NAME
# @DESCRIPTION:
# Set this if the the PEAR package name differs from ${PN/PEAR-/}
# (generally shouldn't be the case).
[[ -z "${PHP_PEAR_PKG_NAME}" ]] && PHP_PEAR_PKG_NAME="${PN/PEAR-/}"

fix_PEAR_PV() {
	tmp="${PV}"
	tmp="${tmp/_/}"
	tmp="${tmp/rc/RC}"
	tmp="${tmp/beta/b}"
	PEAR_PV="${tmp}"
}

# @ECLASS-VARIABLE: PEAR_PV
# @DESCRIPTION:
# Set in ebuild if the eclass ${PV} mangling breaks SRC_URI for beta/rc versions
[[ -z "${PEAR_PV}" ]] && fix_PEAR_PV

PEAR_PN="${PHP_PEAR_PKG_NAME}-${PEAR_PV}"

[[ -z "${SRC_URI}" ]] && SRC_URI="http://pear.php.net/get/${PEAR_PN}.tgz"
[[ -z "${HOMEPAGE}" ]] && HOMEPAGE="http://pear.php.net/${PHP_PEAR_PKG_NAME}"

S="${WORKDIR}/${PEAR_PN}"

# @FUNCTION: php-pear-r1_src_install
# @DESCRIPTION:
# Takes care of standard install for PEAR packages.
php-pear-r1_src_install() {
	# SNMP support
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/
	addpredict /session_mm_cli0.sem

	case "${CATEGORY}" in
		dev-php)
			if has_version '=dev-lang/php-5*' ; then
				PHP_BIN="/usr/lib/php5/bin/php"
			else
				PHP_BIN="/usr/lib/php4/bin/php"
			fi ;;
		dev-php4) PHP_BIN="/usr/lib/php4/bin/php" ;;
		dev-php5) PHP_BIN="/usr/lib/php5/bin/php" ;;
		*) die "Version of PHP required by packages in category ${CATEGORY} unknown"
	esac

	cd "${S}"
	mv -f "${WORKDIR}/package.xml" "${S}"

	if [[ -f "${S}"/package2.xml ]] ; then
		pear -d php_bin="${PHP_BIN}" install --force --loose --nodeps --offline --packagingroot="${D}" "${S}/package2.xml" > /dev/null || die "Unable to install PEAR package"
	else
		pear -d php_bin="${PHP_BIN}" install --force --loose --nodeps --offline --packagingroot="${D}" "${S}/package.xml" > /dev/null || die "Unable to install PEAR package"
	fi

	rm -Rf "${D}/usr/share/php/.channels" \
	"${D}/usr/share/php/.depdblock" \
	"${D}/usr/share/php/.depdb" \
	"${D}/usr/share/php/.filemap" \
	"${D}/usr/share/php/.lock" \
	"${D}/usr/share/php/.registry"
}
