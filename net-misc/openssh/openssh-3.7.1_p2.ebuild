# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openssh/openssh-3.7.1_p2.ebuild,v 1.1 2003/09/23 16:11:55 solar Exp $

inherit eutils flag-o-matic ccc
[ `use kerberos` ] && append-flags -I/usr/include/gssapi

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_/}

#X509_PATCH=${PARCH}+x509g2.diff.gz
SELINUX_PATCH=openssh-3.7.1_p1-selinux.diff.bz2

S=${WORKDIR}/${PARCH}
DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="http://www.openssh.com/"
IUSE="ipv6 static pam tcpd kerberos skey selinux" ; # X509"
SRC_URI="ftp://ftp.openbsd.org/pub/unix/OpenBSD/OpenSSH/portable/${PARCH}.tar.gz
	selinux? ( http://dev.gentoo.org/~pebenito/${SELINUX_PATCH} )"
#	X509? ( http://roumenpetrov.info/openssh/x509g2/${X509_PATCH} )"

# openssh recognizes when openssl has been slightly upgraded and refuses to run.
# This new rev will use the new openssl.
RDEPEND="virtual/glibc
	pam? ( >=sys-libs/pam-0.73
		>=sys-apps/shadow-4.0.2-r2 )
	kerberos? ( app-crypt/mit-krb5 )
	selinux? ( sys-apps/selinux-small )
	skey? ( app-admin/skey )
	>=dev-libs/openssl-0.9.6d
	sys-libs/zlib
	>=sys-apps/sed-4"

DEPEND="${RDEPEND}
	dev-lang/perl
	sys-apps/groff
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~mips ~hppa ~arm ~amd64 ~ia64"

src_unpack() {
	unpack ${PARCH}.tar.gz ; cd ${S}

	use selinux && epatch ${DISTDIR}/${SELINUX_PATCH}
	use alpha && epatch ${FILESDIR}/${PN}-3.5_p1-gentoo-sshd-gcc3.patch
	use X509 && epatch ${DISTDIR}/${X509_PATCH}

	# epatch ${FILESDIR}/${P}-connect-timeout.patch
	# epatch ${FILESDIR}/${P}-double-free.patch
	# epatch ${FILESDIR}/${P}-memory-leak.patch
	# epatch ${FILESDIR}/${P}-memory-bugs.patch

	use skey && {
		# prevent the conftest from violating the sandbox
		sed -i 's#skey_keyinfo("")#"true"#g' configure
	}
}

src_compile() {
	local myconf

	myconf="\
		$( use_with tcpd tcp-wrappers ) \
		$( use_with kerberos kerberos5 ) \
		$( use_with pam ) \
		$( use_with skey )"

	use ipv6 || myconf="${myconf} --with-ipv4-default"

	use skey && {
		# make sure .sbss is large enough
		use alpha && append-ldflags -mlarge-data
	}

	use selinux && append-flags "-DWITH_SELINUX"

	./configure \
		--prefix=/usr \
		--sysconfdir=/etc/ssh \
		--mandir=/usr/share/man \
		--libexecdir=/usr/lib/misc \
		--datadir=/usr/share/openssh \
		--disable-suid-ssh \
		--with-privsep-path=/var/empty \
		--with-privsep-user=sshd \
		--with-md5-passwords \
		--host=${CHOST} ${myconf} || die "bad configure"

	use static && {
		# statically link to libcrypto -- good for the boot cd
		sed -i "s:-lcrypto:/usr/lib/libcrypto.a:g" Makefile
	}

	use selinux && {
		#add -lsecure
		sed -i "s:LIBS=\(.*\):LIBS=\1 -lsecure:" Makefile
	}

	emake || die "compile problem"
}

src_install() {
	make install-files DESTDIR=${D} || die
	chmod 600 ${D}/etc/ssh/sshd_config
	dodoc ChangeLog CREDITS OVERVIEW README* TODO sshd_config
	insinto /etc/pam.d  ; newins ${FILESDIR}/sshd.pam sshd
	exeinto /etc/init.d ; newexe ${FILESDIR}/sshd.rc6 sshd
	keepdir /var/empty/.keep
}

pkg_preinst() {
	userdel sshd 2> /dev/null
	if ! groupmod sshd; then
		groupadd -g 90 sshd 2> /dev/null || \
			die "Failed to create sshd group"
	fi
	useradd -u 22 -g sshd -s /dev/null -d /var/empty -c "sshd" sshd || \
		die "Failed to create sshd user"
}

pkg_postinst() {
	# empty dir for the new priv separation auth chroot..
	install -d -m0755 -o root -g root ${ROOT}/var/empty

	ewarn "Remember to merge your config files in /etc/ssh/ and then"
	ewarn "restart sshd: '/etc/init.d/sshd restart'."
	ewarn
	einfo "As of version 3.4 the default is to enable the UsePrivelegeSeparation"
	einfo "functionality, but please ensure that you do not explicitly disable"
	einfo "this in your configuration as disabling it opens security holes"
	einfo
	einfo "This revision has removed your sshd user id and replaced it with a"
	einfo "new one with UID 22.  If you have any scripts or programs that"
	einfo "that referenced the old UID directly, you will need to update them."
	einfo
	use pam >/dev/null 2>&1 && {
		einfo "Please be aware users need a valid shell in /etc/passwd"
		einfo "in order to be allowed to login."
		einfo
	}
}
