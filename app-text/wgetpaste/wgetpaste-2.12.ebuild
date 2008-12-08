# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wgetpaste/wgetpaste-2.12.ebuild,v 1.2 2008/12/08 00:02:59 darkside Exp $

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="http://wgetpaste.zlin.dk/"
SRC_URI="http://wgetpaste.zlin.dk/${P}.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_install() {
	newbin ${P} ${PN}
}

pkg_postinst() {
	local f oldfiles=()
	for f in "${ROOT}"etc/wgetpaste{,.d/*.bash}; do
		oldfiles+=("${f}")
	done

	if [[ -n ${oldfiles[@]} ]]; then
		ewarn "The config files for wgetpaste have changed to *.conf."
		ewarn
		for f in "${oldfiles[@]}"; do
			ewarn "Please move ${f} to ${f%.bash}.conf"
		done
		ewarn
		ewarn "Users with personal config files will need to do the same for"
		ewarn "~/.wgetpaste and ~/.wgetpaste.d/*.bash."
	fi
}
