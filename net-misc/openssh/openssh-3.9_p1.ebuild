# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openssh/openssh-3.9_p1.ebuild,v 1.5 2004/09/14 08:02:18 aliz Exp $

inherit eutils flag-o-matic ccc gnuconfig

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_/}

SFTPLOG_PATCH_VER="1.2"
X509_PATCH="${PARCH}+x509h.diff.gz"
SELINUX_PATCH="openssh-3.9_p1-selinux.diff"

S=${WORKDIR}/${PARCH}
DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="http://www.openssh.com/"
SRC_URI="mirror://openssh/${PARCH}.tar.gz
	X509? ( http://roumenpetrov.info/openssh/x509h/${X509_PATCH} )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ia64 ~ppc64 ~s390"
IUSE="ipv6 static pam tcpd kerberos skey selinux chroot X509 ldap smartcard uclibc sftplogging"

RDEPEND="virtual/libc
	pam? ( >=sys-libs/pam-0.73
		>=sys-apps/shadow-4.0.2-r2 )
	!mips? ( kerberos? ( virtual/krb5 ) )
	selinux? ( sys-libs/libselinux )
	!ppc64? ( skey? ( >=app-admin/skey-1.1.5-r1 ) )
	>=dev-libs/openssl-0.9.6d
	>=sys-libs/zlib-1.1.4
	x86? ( smartcard? ( dev-libs/opensc ) )
	!ppc64? ( tcpd? ( >=sys-apps/tcp-wrappers-7.6 ) )"
DEPEND="${RDEPEND}
	virtual/os-headers
	dev-lang/perl
	!uclibc? ( sys-apps/groff )
	>=sys-apps/sed-4
	sys-devel/autoconf"
PROVIDE="virtual/ssh"

src_unpack() {
	unpack ${PARCH}.tar.gz ; cd ${S}

	epatch ${FILESDIR}/${P}-largekey.patch.bz2

	use sftplogging && epatch ${FILESDIR}/${P}-sftplogging-1.2-gentoo.patch.bz2
	use alpha && epatch ${FILESDIR}/${PN}-3.5_p1-gentoo-sshd-gcc3.patch.bz2
	use skey && epatch ${FILESDIR}/${P}-skey.patch.bz2
	use chroot && epatch ${FILESDIR}/${P}-chroot.patch.bz2
	use X509 && epatch ${DISTDIR}/${X509_PATCH}
	use selinux && epatch ${FILESDIR}/${SELINUX_PATCH}.bz2
	use smartcard && epatch ${FILESDIR}/${P}-opensc.patch.bz2

	autoconf || die
}

src_compile() {
	local myconf

	addwrite /dev/ptmx
	gnuconfig_update

	# make sure .sbss is large enough
	use skey && use alpha && append-ldflags -mlarge-data
	use ldap && filter-flags -funroll-loops
	use selinux && append-flags "-DWITH_SELINUX"

	if use static; then
		append-ldflags -static
		export LDFLAGS
		if use pam; then
			ewarn "Disabling pam support becuse of static flag."
			myconf="${myconf} --without-pam"
		else
			myconf="${myconf} --without-pam"
		fi
	else
		myconf="${myconf} `use_with pam`"
	fi

	use ipv6 || myconf="${myconf} --with-ipv4-default"

	econf \
		--sysconfdir=/etc/ssh \
		--libexecdir=/usr/lib/misc \
		--datadir=/usr/share/openssh \
		--disable-suid-ssh \
		--with-privsep-path=/var/empty \
		--with-privsep-user=sshd \
		--with-md5-passwords \
		`use_with kerberos kerberos5 /usr` \
		`use_with tcpd tcp-wrappers` \
		`use_with skey` \
		`use_with smartcard opensc` \
		${myconf} \
		|| die "bad configure"

#	use static && {
#		# statically link to libcrypto -- good for the boot cd
#		sed -i "s:-lcrypto:/usr/lib/libcrypto.a:g" Makefile
#	}

	emake || die "compile problem"
}

src_install() {
	make install-files DESTDIR=${D} || die
	chmod 600 ${D}/etc/ssh/sshd_config
	dodoc ChangeLog CREDITS OVERVIEW README* TODO sshd_config
	use pam && ( insinto /etc/pam.d  ; newins ${FILESDIR}/sshd.pam sshd )
	exeinto /etc/init.d ; newexe ${FILESDIR}/sshd.rc6 sshd
	keepdir /var/empty
	dosed "/^#Protocol /s:.*:Protocol 2:" /etc/ssh/sshd_config
	use pam && dosed "/^#UsePAM /s:.*:UsePAM yes:" /etc/ssh/sshd_config
}

pkg_postinst() {
	enewgroup sshd 22
	enewuser sshd 22 /bin/false /var/empty sshd

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
