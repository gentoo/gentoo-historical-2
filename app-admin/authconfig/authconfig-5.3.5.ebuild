# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/authconfig/authconfig-5.3.5.ebuild,v 1.5 2007/10/15 09:36:28 dberkholz Exp $

inherit eutils python rpm

# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it
RPMREV="1"

DESCRIPTION="Tool for setting up authentication from network services"
HOMEPAGE="http://fedoraproject.org/wiki/SystemConfig/"
SRC_URI="mirror://fedora/development/source/SRPMS/${P}-${RPMREV}.src.rpm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
RDEPEND="dev-python/rhpl
	dev-libs/newt
	>=sys-libs/pam-0.99.5
	sys-apps/usermode
	dev-lang/python
	=dev-libs/glib-2*
	dev-perl/XML-Parser
	=dev-python/pygtk-2*"
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
	elog "To activate options in the User Information tab,"
	elog "install the nss_XXX package or another provider of the nss module."
	elog "To activate options in the Authentication tab,"
	elog "install the pam_XXX package or another provider of the pam module."
	elog "If you're curious whether a package installs its own PAM or NSS library,"
	elog "just list the files it installs and grep for pam or nss."
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
