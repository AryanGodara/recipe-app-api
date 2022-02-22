from django.test import TestCase, Client
from django.contrib.auth import get_user_model
from django.urls import reverse

class AdminSiteTests(TestCase):

    def setUp(self):
        """A setup function, is a function that is run before every other test"""
        self.client = Client()
        self.admin_user = get_user_model().objects.create_superuser(
            email='admin@email.com',
            password='admin123'
        )

        self.client.force_login(self.admin_user)
        
        self.user = get_user_model().objects.create_user(
            email = 'test@test.com',
            password = 'pw123',
            name = 'Test user full name'
        )

    def test_users_listed(self):
        """Tests that users are listed on user page"""
        url = reverse('admin:core_user_changelist')
            #? Generate a url for the list user page (reverse, is easier than typing url)
        res = self.client.get(url)
            #? res == response, performs an HTTP GET, on the url we got above

        self.assertContains(res, self.user.name)
        self.assertContains(res, self.user.email)

    def test_user_change_page(self):
        """Tests that the user edit page works"""
        url = reverse('admin:core_user_change', args=[self.user.id])
        # '/admin/core/user/id'
        res = self.client.get(url)

        self.assertEqual(res.status_code, 200)

    def test_create_user_page(self):
        """Tests that the create user page works"""
        url = reverse('admin:core_user_add')
        res = self.client.get(url)

        self.assertEqual(res.status_code, 200)