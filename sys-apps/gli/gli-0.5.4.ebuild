# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gli/gli-0.5.4.ebuild,v 1.3 2008/06/05 20:11:17 wolf31o2 Exp $

inherit python eutils

DESCRIPTION="Gentoo Linux Installer"
HOMEPAGE="http://www.gentoo.org/proj/en/releng/installer/"
#SRC_URI="http://dev.gentoo.org/~agaffney/gli/snapshots/installer-${PV}.tar.bz2"
SRC_URI="mirror://gentoo/installer-${PV}.tar.bz2
	http://dev.gentoo.org/~agaffney/${PN}/releases/installer-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86"
IUSE="gtk"

RDEPEND=">=dev-python/pyparted-1.7.0
	gtk? ( >=dev-python/pygtk-2.4.0 )
	=dev-python/pythondialog-2.7*
	sys-fs/e2fsprogs
	sys-fs/reiserfsprogs
	sys-fs/dosfstools
	sys-fs/xfsprogs
	amd64? ( sys-fs/ntfsprogs )
	ppc? (
		sys-fs/ntfsprogs
		sys-fs/hfsutils
		sys-fs/hfsplusutils )
	x86? (
		sys-fs/ntfsprogs
		sys-fs/hfsutils
		sys-fs/hfsplusutils )"

S=${WORKDIR}/installer-${PV}

dir=/opt/installer
Ddir=${D}/${dir}

src_install() {
	exeinto "${dir}"/bin
	use !gtk && rm -rf ${S}/src/fe/gtk
	# We need to make sure we get our scripts
	doexe "${S}"/bin/installer "${S}"/bin/installer-dialog || \
		die "copying installer scripts"
	cp -a "${S}"/src/* "${Ddir}"
	chown -R root:0 "${Ddir}"
	dodir /usr/bin
	if use gtk; then
		doexe "${S}"/bin/installer-gtk || die "copying gtk script"
		make_wrapper installer-gtk ./installer-gtk "${dir}"/bin
	fi
	make_wrapper installer-dialog ./installer-dialog "${dir}"/bin
	make_wrapper installer ./installer "${dir}"/bin
	doicon "${FILESDIR}"/gli.png ${FILESDIR}/gli-dialog.png
	domenu "${FILESDIR}"/installer-gtk.desktop \
		"${FILESDIR}"/installer-dialog.desktop \
		"${FILESDIR}"/installer-faq.desktop
}

pkg_postinst() {
	python_mod_optimize "${dir}"
	einfo "The Gentoo Linux Installer is currently only usable for two situations."
	einfo "The first is for building an install profile."
	einfo "The second is for installing using official Gentoo release media."
	echo
	ewarn "If you are trying to use the installer for anything else, please"
	ewarn "file patches with any bugs."
	echo
}
