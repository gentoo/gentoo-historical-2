# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-words/twisted-words-0.1.0-r2.ebuild,v 1.1 2006/06/26 21:46:22 marienz Exp $

MY_PACKAGE=Words

inherit twisted

DESCRIPTION="Twisted Words contains Instant Messaging implementations."

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND=">=dev-python/twisted-2
	<dev-python/twisted-2.4
	dev-python/twisted-web
	dev-python/twisted-xish
	gtk? ( <dev-python/pygtk-2 )"

IUSE="gtk"


src_install() {
	twisted_src_install

	if ! use gtk; then
		# Remove the "im" script if we do not depend on the required pygtk.
		rm -rf "${D}"/usr/{bin,share/man}
	fi
}
