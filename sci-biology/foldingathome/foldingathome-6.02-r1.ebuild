# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/foldingathome/foldingathome-6.02-r1.ebuild,v 1.1 2008/11/22 21:31:26 je_fro Exp $

I="/opt/foldingathome"

inherit eutils

DESCRIPTION="Folding@Home is a distributed computing project for protein folding."
HOMEPAGE="http://folding.stanford.edu/FAQ-SMP.html"
SRC_URI="http://www.stanford.edu/group/pandegroup/folding/release/FAH6.02-Linux.tgz"

LICENSE="folding-at-home"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-libs/glibc-2.3.0
		amd64? ( app-emulation/emul-linux-x86-baselibs )"

RDEPEND=""

S="${WORKDIR}"

src_install() {
	exeinto ${I}
	newexe "${FILESDIR}"/${PV}/initfolding initfolding
	doexe fah6 mpiexec
	newconfd "${FILESDIR}"/${PV}/folding-conf.d foldingathome
	newinitd "${FILESDIR}"/${PV}/fah-init foldingathome
}

pkg_preinst() {
	# the bash shell is important for "su -c" in init script
	enewuser foldingathome -1 /bin/bash /opt/foldingathome
}

pkg_postinst() {
	chown -R foldingathome:nogroup /opt/foldingathome
	einfo "To run Folding@home in the background at boot:"
	einfo " rc-update add foldingathome default"
	einfo ""
	einfo "Please run ${I}/initfolding to configure your client"
	einfo "and edit /etc/conf.d/foldingathome for options"
	einfo ""
}

pkg_postrm() {
	einfo "Folding@home data files were not removed."
	einfo " Remove them manually from ${I}"
	einfo ""
}
