# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Crypt_CHAP/PEAR-Crypt_CHAP-1.5.0.ebuild,v 1.1 2012/01/18 18:15:52 mabi Exp $

EAPI="4"

inherit php-pear-r1

DESCRIPTION="Generating CHAP packets"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

pkg_postinst() {
	if ! has_version "=dev-lang/php[crypt,mhash]" ; then
		elog "${PN} can optionally use dev-lang/php crypt and mhash features."
		elog "If you want those, recompile dev-lang/php with these flags in USE."
	fi
}
