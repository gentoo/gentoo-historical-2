# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/rgmanager/rgmanager-2.02.00-r1.ebuild,v 1.1 2008/03/23 17:20:51 xmerlin Exp $

inherit eutils versionator

CVS_RELEASE="20080323"
CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2).$(get_version_component_range 3)"

DESCRIPTION="Clustered resource group manager"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz
	mirror://gentoo/gfs-${PV}-${CVS_RELEASE}-cvs.patch.bz2
	http://dev.gentoo.org/~xmerlin/gfs/gfs-${PV}-${CVS_RELEASE}-cvs.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=sys-cluster/ccs-${CLUSTER_RELEASE}*
	=sys-cluster/dlm-lib-${CLUSTER_RELEASE}*
	=sys-cluster/cman-lib-${CLUSTER_RELEASE}*
	"

DEPEND="${RDEPEND}
	dev-libs/libxml2
	=sys-libs/slang-2*
	"

S="${WORKDIR}/${MY_P}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	(cd "${WORKDIR}"/${MY_P};
		epatch "${WORKDIR}"/gfs-2.02.00-20080323-cvs.patch || die
	)
}

src_compile() {
	(cd "${WORKDIR}"/${MY_P};
		./configure \
			--cc=$(tc-getCC) \
			--cflags="-Wall" \
			--disable_kernel_check \
			--somajor="$MAJ_PV" \
			--sominor="$MIN_PV" \
			--dlmlibdir=/usr/lib \
			--dlmincdir=/usr/include \
			--cmanlibdir=/usr/lib \
			--cmanincdir=/usr/include \
	) || die "configure problem"

	# fix the manual pages have executable bit
	sed -i -e '
		/\tinstall -d/s/install/& -m 0755/; t
		/\tinstall/s/install/& -m 0644/' \
		man/Makefile

	# There's a problem with -O2 right now, a patch was submitted.
	env -u CFLAGS emake -j1 clean all || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install || die "install problem"

	newinitd "${FILESDIR}"/${PN}-2.0x.rc ${PN} || die
	newconfd "${FILESDIR}"/${PN}-2.0x.conf ${PN} || die
}
