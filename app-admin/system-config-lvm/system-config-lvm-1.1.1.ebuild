# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/system-config-lvm/system-config-lvm-1.1.1.ebuild,v 1.2 2007/10/15 09:25:41 dberkholz Exp $

inherit python eutils rpm

# Tag for which Fedora Core version it's from
FCVER="7"
# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it
RPMREV="1.0"

DESCRIPTION="A utility for graphically configuring Logical Volumes"
HOMEPAGE="http://fedoraproject.org/wiki/SystemConfig/lvm"
SRC_URI="mirror://fedora/development/source/SRPMS/${P}-${RPMREV}.fc${FCVER}.src.rpm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""
RDEPEND="=dev-python/gnome-python-2*
	=dev-python/pygtk-2*
	dev-python/rhpl
	dev-lang/python
	>=sys-fs/lvm2-2.00.20"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	dev-perl/XML-Parser"

src_unpack() {
	rpm_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gentoo.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	make_desktop_entry /usr/bin/${PN}

	fperms 644 /etc/pam.d/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
