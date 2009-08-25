# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-passwd/horde-passwd-3.1.1.ebuild,v 1.4 2009/08/25 14:26:17 klausman Exp $

HORDE_PHP_FEATURES="ctype"

HORDE_MAJ="-h3"
inherit horde eutils

DESCRIPTION="Horde Passwd is the Horde password changing application"

KEYWORDS="alpha amd64 ~hppa ~ppc ~sparc x86"
IUSE="clearpasswd"

DEPEND=""
RDEPEND="|| ( >=www-apps/horde-3 >=www-apps/horde-groupware-1 >=www-apps/horde-webmail-1 )"

src_unpack() {
	horde_src_unpack
	cd "${S}"
	use clearpasswd || epatch "${FILESDIR}"/${PN}-3.0-no-clear-password.patch
}
