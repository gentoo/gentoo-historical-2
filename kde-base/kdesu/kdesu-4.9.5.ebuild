# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesu/kdesu-4.9.5.ebuild,v 1.1 2013/01/05 20:19:09 creffett Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kde-runtime"
inherit kde4-meta

# FIXME: Is default command ( su/sudo ) still configurable,
# if not, USE-flag ?
DESCRIPTION="KDE: gui for su(1)"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

src_configure() {
	# Upstream moved kdesu to libexec first, then decided to move it back
	# to /${PREFIX}/bin/ , so I'm doing that now already.
	sed -e '/kdesu_executable/s:LIBEXEC_INSTALL_DIR:BIN_INSTALL_DIR:' \
		-i "${S}"/kdesu/kdesu/CMakeLists.txt || \
		die "Moving kdesu from libexec to bin failed."

	kde4-meta_src_configure
}
