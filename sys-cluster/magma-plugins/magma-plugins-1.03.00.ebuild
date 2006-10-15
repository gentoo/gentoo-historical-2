# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/magma-plugins/magma-plugins-1.03.00.ebuild,v 1.3 2006/10/15 13:26:06 xmerlin Exp $

MY_P="cluster-${PV}"

DESCRIPTION="Magma cluster interface plugins"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
#IUSE="nogulm"
IUSE=""

DEPEND=">=sys-cluster/magma-1.03.00
	>=sys-cluster/dlm-1.03.00
	>=sys-cluster/cman-1.03.00
	"

#	!nogulm? ( >=sys-cluster/gulm-1.03.00 )"


S="${WORKDIR}/${MY_P}/${PN}"

src_compile() {
	./configure || die "configure problem"

	for i in cman dumb sm; do
		emake -C ${i} all || die "compile problem"
	done
#	use nogulm || emake -C gulm all
}

src_install() {
	for i in cman dumb sm; do
		make -C ${i} DESTDIR=${D} install || die "install problem"
	done
#	use nogulm || make -C gulm DESTDIR=${D} install || die
}
