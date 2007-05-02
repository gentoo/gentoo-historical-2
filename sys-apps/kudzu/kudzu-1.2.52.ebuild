# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kudzu/kudzu-1.2.52.ebuild,v 1.4 2007/05/02 06:46:27 dberkholz Exp $

inherit eutils python rpm multilib

# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it
RPMREV="1"

MY_P="${PN/lib}-${PV}"

DESCRIPTION="Red Hat Hardware detection tools"
SRC_URI="mirror://fedora/development/source/SRPMS/${MY_P}-${RPMREV}.src.rpm"
HOMEPAGE="http://rhlinux.redhat.com/kudzu/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="dev-libs/popt
	sys-apps/hwdata-redhat
	!sys-libs/libkudzu"
DEPEND="dev-libs/popt
	sys-apps/pciutils"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	rpm_src_unpack
	cd "${S}"
	epatch \
		"${FILESDIR}"/sunlance.patch \
		"${FILESDIR}"/${PV}-remove-sata-ata-storage-classes.patch \
		"${FILESDIR}"/${PV}-remove-pci-fill-class.patch \
		"${FILESDIR}"/${PV}-remove-pci-device-class.patch
}

src_compile() {
	emake \
		all \
		RPM_OPT_FLAGS="${CFLAGS}" || die
}

src_install() {
	emake install install-program \
		DESTDIR="${D}" \
		libdir="${D}/usr/$(get_libdir)" \
		|| die "install failed"

	# don't install incompatible init scripts
	rm -rf \
		"${D}"/etc/rc.d \
		|| die "removing rc.d files failed"
}

pkg_postrm() {
	python_mod_cleanup
}
