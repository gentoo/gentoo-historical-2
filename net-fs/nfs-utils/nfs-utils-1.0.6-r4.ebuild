# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/nfs-utils/nfs-utils-1.0.6-r4.ebuild,v 1.3 2004/10/09 14:34:18 joker Exp $

inherit gnuconfig

DESCRIPTION="NFS client and server daemons"
HOMEPAGE="http://nfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/nfs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm hppa ~mips ~ppc ~ppc64 s390 sparc x86"
IUSE="tcpd"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )"
RDEPEND="${DEPEND}
	>=net-nds/portmap-5b-r6
	>=sys-apps/util-linux-2.11f"

src_compile() {
	gnuconfig_update
	econf \
		--mandir=/usr/share/man \
		--with-statedir=/var/lib/nfs \
		--disable-rquotad \
		--enable-nfsv3 \
		--enable-secure-statd \
		|| die "Configure failed"

	if ! use tcpd; then
		sed -i "s:\(-lwrap\|-DHAVE_TCP_WRAPPER\)::" config.mk
	fi

	# parallel make fails for depend target
	make depend || die "failed to make depend"
	emake || die "Failed to compile"
}

src_install() {
	make install install_prefix=${D} MANDIR=${D}/usr/share/man \
		|| die "Failed to install"

	# Don't overwrite existing xtab/etab, install the original
	# versions somewhere safe...  more info in pkg_postinst
	dodir /usr/lib/nfs
	keepdir /var/lib/nfs/{sm,sm.bak}
	mv ${D}/var/lib/nfs/* ${D}/usr/lib/nfs
	keepdir /var/lib/nfs
	keepdir /var/lib/nfs/v4root

	# Install some client-side binaries in /sbin
	dodir /sbin
	mv ${D}/usr/sbin/rpc.{lockd,statd} ${D}/sbin

	dodoc ChangeLog README
	docinto linux-nfs ; dodoc linux-nfs/*

	insinto /etc ; doins ${FILESDIR}/exports

	exeinto /etc/init.d
	newexe ${FILESDIR}/nfs-5 nfs
	newexe ${FILESDIR}/nfsmount nfsmount

	insinto /etc/conf.d
	newins ${FILESDIR}/nfs.confd nfs
}

pkg_postinst() {
	# Install default xtab and friends if there's none existing.
	# In src_install we put them in /usr/lib/nfs for safe-keeping, but
	# the daemons actually use the files in /var/lib/nfs.  This fixes
	# bug 30486
	local f
	for f in ${ROOT}/usr/lib/nfs/*; do
		[[ -f ${ROOT}/var/lib/nfs/${f##*/} ]] && continue
		einfo "Copying default ${f##*/} from /usr/lib/nfs to /var/lib/nfs"
		cp -a ${f} ${ROOT}/var/lib/nfs/
	done

	echo
	einfo "NFS V2 and V3 servers now default to \"sync\" IO if ${P}"
	einfo "(or later) is installed."
	einfo "More info at ${HOMEPAGE} (see questions 5, 12, 13, and 14)."
	echo
	einfo "If you plan on using NFS V4 then you should emerge the idmapd"
	einfo "package now."
	echo
	ewarn "PLEASE note: Since the latest NFS utils has changed the server"
	ewarn "default to \"sync\" IO, then if no behavior is specified in the"
	ewarn "export list, thus assuming the default behavior, a warning will"
	ewarn "be generated at export time."
	echo
}
