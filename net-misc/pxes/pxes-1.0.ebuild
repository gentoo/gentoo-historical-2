# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pxes/pxes-1.0.ebuild,v 1.5 2006/03/20 21:12:27 wolf31o2 Exp $

inherit eutils perl-app

IUSE="cdr"
DESCRIPTION="PXES is a package for building thin clients using multiple types of clients"
HOMEPAGE="http://pxes.sourceforge.net"
SRC_URI="mirror://sourceforge/pxes/${PN}-base-i586-${PV}-6.tar.gz
	mirror://sourceforge/pxes/pxesconfig-${PV}-7.tar.gz"

KEYWORDS="amd64 x86"

SLOT="0"
LICENSE="GPL-2"
DEPEND=">=dev-lang/perl-5.8.0-r12"

RDEPEND="${DEPEND}
	dev-perl/gtk-perl
	>=dev-perl/glade-perl-0.61
	sys-fs/squashfs-tools
	cdr? ( app-cdr/cdrtools )"

dir=/opt/${P}
Ddir=${D}/${dir}

die_from_busted_gtk-perl() {
	ewarn "PXES requires that gtk-perl was built with USE=gnome. You can"
	ewarn "fix this by doing the following:"
	echo
	einfo "mkdir -p /etc/portage"
	einfo "echo 'dev-perl/gtk-perl gnome' >> /etc/portage/package.use"
	einfo "emerge --oneshot dev-perl/gtk-perl"
	die "gtk-perl requires USE=gnome"
}

pkg_setup() {
	built_with_use dev-perl/gtk-perl gnome || die_from_busted_gtk-perl
}

src_compile() {
	cd ${WORKDIR}/pxesconfig-${PV}
	SRC_PREP="yes"
	perl Makefile.PL PREFIX=${D}/usr INSTALLDIRS=vendor DESTDIR=${D}
	perl-app_src_compile || die
}

src_install() {
	dodir ${dir}
	cp -r ${S}/stock ${Ddir} || die "Copying files"
	cp -pPR ${S}/tftpboot ${D} || die "Copying tftpboot"
	dodir ${dir}/tools
	dosym /usr/bin/mksquashfs ${dir}/tools/mksquashfs
	dodoc Documentation/ChangeLog
	dohtml -r Documentation/html/*
	cd ${WORKDIR}/pxesconfig-${PV}
	perl-module_src_install || die
	# Cleanup from improper install
	cp -r ${D}/${D}/usr ${D}
	rm -rf ${D}/var
}
