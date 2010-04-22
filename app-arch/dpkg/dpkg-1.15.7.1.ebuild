# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/dpkg/dpkg-1.15.7.1.ebuild,v 1.1 2010/04/22 14:23:03 jer Exp $

EAPI=3

inherit eutils multilib autotools

DESCRIPTION="Package maintenance system for Debian"
HOMEPAGE="http://packages.qa.debian.org/dpkg"
SRC_URI="mirror://debian/pool/main/d/${PN}/${P/-/_}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-solaris ~x86-solaris"
IUSE="bzip2 dselect nls test unicode zlib"

LANGS="sv de es ja fr hu pl ru"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND=">=dev-lang/perl-5.6.0
	dev-perl/TimeDate
	>=sys-libs/ncurses-5.2-r7
	zlib? ( >=sys-libs/zlib-1.1.4 )
	bzip2? ( app-arch/bzip2 )"
DEPEND="${RDEPEND}
	nls? ( app-text/po4a )
	test? ( dev-perl/Test-Pod dev-perl/IO-String )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.15.5.6-bootstrap.patch

	# don't mess with linker optimisation, respect user's flags (don't break!)
	sed -i -e '/DPKG_LINKER_OPTIMISATIONS/d' configure.ac || die

	# Force the use of the running bash for get-version (this file is never
	# installed, so no need to worry about hardcoding a temporary bash)
	sed -i -e '1c\#!'"${BASH}" get-version || die

	# bug 310847
	if [[ "${PV}" = "1.15.7" ]]; then
		sed -i lib/dpkg/test/Makefile.am -e '/t[_-]ar/d' || die "sed failed"
		sed -i scripts/Makefile.am -e '/850_Dpkg_Compression.t/d' \
			|| die "sed failed"
	fi

	eautoreconf
}

src_configure() {
	local myconf
	if use nls; then
		myconf="--enable-nls $(use_with dselect)"
	else
		if use dselect; then
			elog "Building dselect requires USE=nls - disabling USE=dselect..."
		fi
		myconf="--disable-nls --without-dselect"
	fi
	econf \
		${myconf} \
		$(use_with bzip2 bz2) \
		$(use_enable unicode) \
		$(use_with zlib) \
		--without-selinux \
		--without-start-stop-daemon
}

src_install() {
	strip-linguas ${LANGS}
	if [ -z "${LINGUAS}" ] ; then
		LINGUAS=none
	fi

	emake DESTDIR="${D}" LINGUAS="${LINGUAS}" install || die "emake install failed"
	rm "${ED}"/usr/sbin/install-info || die "rm install-info failed"
	dodoc ChangeLog INSTALL THANKS TODO
	keepdir /usr/$(get_libdir)/db/methods/{mnt,floppy,disk}
	keepdir /usr/$(get_libdir)/db/{alternatives,info,methods,parts,updates}
}
