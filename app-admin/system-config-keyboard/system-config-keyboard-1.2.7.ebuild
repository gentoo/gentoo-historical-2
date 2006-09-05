# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/system-config-keyboard/system-config-keyboard-1.2.7.ebuild,v 1.1 2006/09/05 21:42:33 dberkholz Exp $

inherit rpm

# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it
RPMREV="2"

DESCRIPTION="A graphical interface for modifying the keyboard"
HOMEPAGE="http://fedora.redhat.com/projects/config-tools/"
SRC_URI="mirror://fedora/development/source/SRPMS/${P}-${RPMREV}.src.rpm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
RDEPEND=">=x11-libs/gtk+-2.6
	dev-lang/python
	sys-apps/usermode
	dev-python/pyxf86config
	dev-python/rhpl
	x11-themes/hicolor-icon-theme"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool"
PDEPEND="app-admin/firstboot"

src_install() {
	emake \
		INSTROOT="${D}" \
		RPM_BUILD_ROOT="${D}" \
		install \
		|| die "emake install failed"

	make_desktop_entry /usr/bin/${PN}

	fperms 644 /etc/pam.d/${PN}
}
