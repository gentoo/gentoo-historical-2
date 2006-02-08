# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/e2fsprogs/e2fsprogs-1.38-r1.ebuild,v 1.3 2006/02/08 01:17:03 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Standard EXT2 and EXT3 filesystem utilities"
HOMEPAGE="http://e2fsprogs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls static"

RDEPEND="~sys-libs/com_err-${PV}
	~sys-libs/ss-${PV}"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	sys-apps/texinfo"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Fix locale issues while running tests #99766
	epatch "${FILESDIR}"/${P}-tests-locale.patch
	# Fix a cosmetic error in mk_cmds's help output.
	epatch "${FILESDIR}"/e2fsprogs-1.32-mk_cmds-cosmetic.patch
	chmod u+w po/*.po # Userpriv fix #27348
	# Clean up makefile to suck less
	epatch "${FILESDIR}"/e2fsprogs-1.36-makefile.patch
	# Fix segfault with disconnected inodes #91751
	epatch "${FILESDIR}"/${P}-disconnected-inodes.patch

	# Fixes from upstream
	epatch "${FILESDIR}"/${P}-blkid-ext23.patch
	epatch "${FILESDIR}"/${P}-blkid-swsuspend.patch
	epatch "${FILESDIR}"/${P}-vfat-labels.patch

	# kernel headers use the same defines as e2fsprogs and can cause issues #48829
	sed -i \
		-e 's:CONFIG_JBD_DEBUG:__CONFIG_JBD_DEBUG__E2FS:g' \
		$(grep -rl CONFIG_JBD_DEBUG *) \
		|| die "sed jbd debug failed"

	# building e2fsprogs on sparc results in silo breaking
	[[ ${ARCH} == "sparc" ]] && filter-flags -fstack-protector

	# fake out files we forked into sep packages
	sed -i \
		-e '/^LIB_SUBDIRS/s:lib/et::' \
		-e '/^LIB_SUBDIRS/s:lib/ss::' \
		Makefile.in || die "remove subdirs"
	ln -s "${ROOT}"/usr/$(get_libdir)/libcom_err.a lib/libcom_err.a
	ln -s "${ROOT}"/$(get_libdir)/libcom_err.so lib/libcom_err.so
	ln -s /usr/bin/mk_cmds lib/ss/mk_cmds
	ln -s "${ROOT}"/usr/include/ss/ss_err.h lib/ss/
	ln -s "${ROOT}"/$(get_libdir)/libss.so lib/libss.so

	# sanity check for Bug 105304
	if [[ -z ${USERLAND} ]] ; then
		eerror "You just hit Bug 105304, please post your 'emerge info' here:"
		eerror "http://bugs.gentoo.org/105304"
		die "Aborting to prevent screwing your system"
	fi
}

src_compile() {
	# Keep the package from doing silly things
	export LDCONFIG=/bin/true
	export CC=$(tc-getCC)
	export STRIP=/bin/true

	econf \
		--bindir=/bin \
		--sbindir=/sbin \
		--enable-elf-shlibs \
		--with-ldopts="${LDFLAGS}" \
		$(use_enable !static dynamic-e2fsck) \
		--without-included-gettext \
		$(use_enable nls) \
		$(use_enable userland_GNU fsck) \
		|| die
	if [[ ${CHOST} != *-uclibc ]] && grep -qs 'USE_INCLUDED_LIBINTL.*yes' config.{log,status} ; then
		eerror "INTL sanity check failed, aborting build."
		eerror "Please post your ${S}/config.log file as an"
		eerror "attachment to http://bugs.gentoo.org/show_bug.cgi?id=81096"
		die "Preventing included intl cruft from building"
	fi
	mkdir -p lib/{blkid,e2p,et,ext2fs,ss,uuid}/{checker,elfshared,pic,profiled} #102412
	# Parallel make sometimes fails
	emake -j1 COMPILE_ET=compile_et || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog README RELEASE-NOTES SHLIBS
	docinto e2fsck
	dodoc e2fsck/ChangeLog e2fsck/CHANGES

	# Move shared libraries to /lib/, install static libraries to /usr/lib/,
	# and install linker scripts to /usr/lib/.
	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/*.so* "${D}"/$(get_libdir)/
	dolib.a lib/*.a || die "dolib.a"
	local x
	cd "${D}"/$(get_libdir)
	for x in *.so ; do
		gen_usr_ldscript ${x} || die "gen ldscript ${x}"
	done

	# move 'useless' stuff to /usr/
	dosbin "${D}"/sbin/mklost+found
	rm -f "${D}"/sbin/mklost+found

	# these manpages are already provided by FreeBSD libc
	use elibc_FreeBSD && \
		rm -f "${D}"/usr/share/man/man3/{uuid,uuid_compare}.3 \
			"${D}"/usr/share/man/man1/uuidgen.1
}
