# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/system-config-samba/system-config-samba-1.2.35.ebuild,v 1.4 2007/04/25 02:16:32 dberkholz Exp $

inherit python eutils rpm

# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it
RPMREV="1.1"

DESCRIPTION="Samba server configuration tool"
HOMEPAGE="http://fedora.redhat.com/projects/config-tools/"
SRC_URI="mirror://fedora/development/source/SRPMS/${P}-${RPMREV}.src.rpm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
RDEPEND="=dev-python/pygtk-2*
	dev-lang/python
	sys-apps/usermode
	dev-python/rhpl
	net-fs/samba
	www-client/htmlview
	x11-themes/hicolor-icon-theme"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool"

src_unpack() {
	rpm_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gentooify.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	make_desktop_entry /usr/bin/${PN}

	fperms 644 /etc/pam.d/${PN}
}

pkg_postinst() {
	elog "Note that shares named global, printers and homes"
	elog "will not show up on the shares list. This is on purpose."
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
