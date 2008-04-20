# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/nfs-utils/nfs-utils-1.1.1.ebuild,v 1.3 2008/04/20 00:52:23 vapier Exp $

inherit eutils flag-o-matic multilib

DESCRIPTION="NFS client and server daemons"
HOMEPAGE="http://nfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/nfs/${P}.tar.gz
	http://www.citi.umich.edu/projects/nfsv4/linux/nfs-utils-patches/1.1.1-1/nfs-utils-1.1.1-001-xlog_segfault_fix.dif
	http://www.citi.umich.edu/projects/nfsv4/linux/nfs-utils-patches/1.1.1-1/nfs-utils-1.1.1-002-svcgssd_pass_down_principal_name.dif"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nonfsv4 tcpd kerberos"

# kth-krb doesn't provide the right include
# files, and nfs-utils doesn't build against heimdal either,
# so don't depend on virtual/krb.
# (04 Feb 2005 agriffis)
RDEPEND="tcpd? ( sys-apps/tcp-wrappers )
	>=net-nds/portmap-5b-r6
	!nonfsv4? (
		>=dev-libs/libevent-1.0b
		>=net-libs/libnfsidmap-0.16
		kerberos? (
			net-libs/librpcsecgss
			net-libs/libgssglue
			app-crypt/mit-krb5
		)
	)"
# util-linux dep is to prevent man-page collision
DEPEND="${RDEPEND}
	>=sys-apps/util-linux-2.12r-r7"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	epatch "${DISTDIR}"/nfs-utils-1.1.1-001-xlog_segfault_fix.dif "${DISTDIR}"/nfs-utils-1.1.1-002-svcgssd_pass_down_principal_name.dif
	sed -i \
		-e 's:libgssapi >= 0\.11:libgssglue >= 0.1:' \
		-e 's:-lgssapi:-lgssglue:' \
		configure #191746
}

src_compile() {
	econf \
		--mandir=/usr/share/man \
		--with-statedir=/var/lib/nfs \
		--disable-rquotad \
		--enable-nfsv3 \
		--enable-secure-statd \
		$(use_with tcpd tcp-wrappers) \
		$(use_enable !nonfsv4 nfsv4) \
		$(use !nonfsv4 && use_enable kerberos gss) \
		|| die "Configure failed"
	emake || die "Failed to compile"
}

src_install() {
	emake DESTDIR="${D}" install || die

	# Don't overwrite existing xtab/etab, install the original
	# versions somewhere safe...  more info in pkg_postinst
	dodir /usr/lib/nfs
	keepdir /var/lib/nfs/{sm,sm.bak}
	mv "${D}"/var/lib/nfs/* "${D}"/usr/lib/nfs
	keepdir /var/lib/nfs

	# Install some client-side binaries in /sbin
	dodir /sbin
	mv "${D}"/usr/sbin/rpc.statd "${D}"/sbin/ || die

	dodoc ChangeLog README
	docinto linux-nfs ; dodoc linux-nfs/*

	insinto /etc
	doins "${FILESDIR}"/exports

	local f list=""
	if use !nonfsv4 ; then
		list="${list} rpc.idmapd"
		use kerberos && list="${list} rpc.gssd rpc.svcgssd"
	fi
	for f in nfs nfsmount rpc.statd ${list} ; do
		newinitd "${FILESDIR}"/${f}.initd ${f} || die "doinitd ${f}"
	done
	newconfd "${FILESDIR}"/nfs.confd nfs
	use !nonfsv4 && doins utils/idmapd/idmapd.conf

	# uClibc doesn't provide rpcgen like glibc, so lets steal it from nfs-utils
	if ! use elibc_glibc ; then
		dobin tools/rpcgen/rpcgen || die "rpcgen"
		newdoc tools/rpcgen/README README.rpcgen
	fi
}

pkg_preinst() {
	[[ -s ${ROOT}/etc/exports ]] && rm -f "${D}"/etc/exports
}

pkg_postinst() {
	# Install default xtab and friends if there's none existing.
	# In src_install we put them in /usr/lib/nfs for safe-keeping, but
	# the daemons actually use the files in /var/lib/nfs.  This fixes
	# bug 30486
	local f
	for f in "${ROOT}"/usr/$(get_libdir)/nfs/*; do
		[[ -e ${ROOT}/var/lib/nfs/${f##*/} ]] && continue
		einfo "Copying default ${f##*/} from /usr/$(get_libdir)/nfs to /var/lib/nfs"
		cp -pPR "${f}" "${ROOT}"/var/lib/nfs/
	done
}
