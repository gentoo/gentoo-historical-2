# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/fence/fence-2.02.00.ebuild,v 1.1 2008/03/17 16:38:40 xmerlin Exp $

inherit eutils versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2).$(get_version_component_range 3)"

DESCRIPTION="I/O group fencing system"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=sys-cluster/ccs-${CLUSTER_RELEASE}*
	=sys-cluster/openais-0.82*
	=sys-cluster/dlm-lib-${CLUSTER_RELEASE}*
	=sys-cluster/cman-lib-${CLUSTER_RELEASE}*
	dev-perl/Net-Telnet
	dev-perl/Net-SSLeay
	"

RDEPEND="$DEPEND"

S="${WORKDIR}/${MY_P}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	chmod u+x "${WORKDIR}"/${MY_P}/scripts/define2var
}

src_compile() {
	(cd "${WORKDIR}"/${MY_P};
		./configure \
			--cc=$(tc-getCC) \
			--cflags="-Wall" \
			--disable_kernel_check \
			--release_major="$MAJ_PV" \
			--release_minor="$MIN_PV" \
			--dlmlibdir=/usr/lib \
			--dlmincdir=/usr/include \
			--cmanlibdir=/usr/lib \
			--cmanincdir=/usr/include \
	) || die "configure problem"

	(cd "${WORKDIR}"/${MY_P}/group;
		emake -j1 clean all \
	) || die "compile problem"

	# fix the manual pages have executable bit
	sed -i -e '
		/\tinstall -d/s/install/& -m 0755/; t
		/\tinstall/s/install/& -m 0644/' \
		man/Makefile

	emake -j1 clean all || die "compile problem"
}

src_install() {
	(cd "${WORKDIR}"/${MY_P}/group;
		emake DESTDIR="${D}" install \
	) || die "install problem"

	emake DESTDIR="${D}" install || die "install problem"
}
